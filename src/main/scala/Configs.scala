package zcu102

import freechips.rocketchip.config._
import freechips.rocketchip.devices.debug._
import freechips.rocketchip.devices.tilelink.BootROMLocated
import freechips.rocketchip.subsystem._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.subsystem.MemoryPortParams

class WithBootROMResetAddress(resetAddress: BigInt)
  extends Config((_, _, up) => {
    case BootROMLocated(x) =>
      up(BootROMLocated(x)).map(_.copy(hang = resetAddress))
  })

class WithIDBits(n: Int)
  extends Config((site, here, up) => {
    case ExtMem =>
      up(ExtMem, site).map(x => x.copy(master = x.master.copy(idBits = n)))
    case ExtBus => up(ExtBus, site).map(x => x.copy(idBits = n))
  })

class WithCustomMMIOPort
  extends Config((site, _, up) => {
    case ExtBus =>
      Some(
        MasterPortParams(
          base = x"6000_0000",
          size = x"2000_0000",
          beatBytes = site(MemoryBusKey).beatBytes,
          idBits = 4
        )
      )
  })

class WithCustomMemPort
  extends Config((site, here, up) => {
    case ExtMem =>
      Some(
        MemoryPortParams(
          MasterPortParams(
            base = x"1_0000_0000",
            size = x"1000_0000",
            beatBytes = site(MemoryBusKey).beatBytes,
            idBits = 4
          ),
          1
        )
      )
  })

class WithCustomJtag
  extends Config((site, here, up) => {
    case JtagDTMKey =>
      new JtagDTMConfig(
        idcodeVersion = 1,
        idcodePartNum = 0,
        idcodeManufId = 0x489, // SiFive
        debugIdleCycles = 5
      )
  })

class RocketConfig
  extends Config(
    new WithCoherentBusTopology ++
      new WithoutTLMonitors ++
      new WithIDBits(5) ++
      new WithJtagDTM ++
      new WithNBigCores(4) ++
      new WithBootROMResetAddress(0x10000) ++
      new WithNExtTopInterrupts(6) ++
      new WithCustomMemPort ++
      new WithCustomMMIOPort ++
      new freechips.rocketchip.system.BaseConfig
  )
