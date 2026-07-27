// Copyright (c) The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef BITCOIN_COMMON_SYSTEM_RAM_H
#define BITCOIN_COMMON_SYSTEM_RAM_H

#include <cstdint>
#include <optional>

/**
 * Return the total RAM available on the current system, if detectable.
 */
std::optional<uint64_t> TryGetTotalRam();

#endif // BITCOIN_COMMON_SYSTEM_RAM_H
