Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.54.127.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795781726;
	b=dAAy2fBQBlDT5EIlxKiMIatv+NlKCGe99g+OkEZVBbILwmM9GDHS9i1An7CuZ9toWlR2
	 TWXdI+RpyMHteODkHtlbRHEQFxqQtIdDjO7BU2FjrSOLw728c+EMzn5BFbmUb+w9ojZIG
	 pTxlV34764eTO3WgcZrD08GAivE9kyrwN/rD686QNfjeUm1HPnuOxuq7AEHOAVYAxlbLM
	 YM455LObGndwr74HedS4MPN2HG8Gg9F0nGgo87t5Ius27cKlXXCVa1m+tCIAsvu5PFJs7
	 b9ooUyTBCBB2+mHv7tB8iNkTHwQgZuCAxsfW1HE9Xxnl1GsBZk+UMUmFdW4dnJZLk6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781726;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Envelope-From;
	bh=aTabeef5xq+0WitgzWBj+jPPdEI37fOW2SVHdZQA62A=;
	b=c2WkupVrPOGBcz/YEjcgOZ3lQTCZi8nlgmZtFPqC2nyFqI1GgkWd6CTYLkn334PNmNhJ
	 G+wV5BTRmwQYb+OhE3ouGBFUy3ZtkfYx0QbxgbuILFzQkGXh0pFxNc+mDA2e+17Zs0VbQ
	 YEh1ui95bqL9u8agF5sLfpPb039s6dX3nKknXcYd6pPUVXyvARq7whA8GKY9+ySKW6r5U
	 v1587mZkAZvSLKbQUL7CmGYfaxe4NI8HRxhHeSNuZ3kou0LfOxHTDKaZyZ8GegxUwc0W0
	 nlKMCX+tmpzHqHzzjnlwRX/bL12EDEF3KCrL6jZxapp0J6y+CwmuAk9jezqg9DC8OaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tychen.cc;
	spf=pass smtp.mailfrom=tychen.cc;
	dkim=pass header.d=tychen.cc header.i=@tychen.cc header.a=rsa-sha256 header.s=spacemail header.b=Ww942AoB;
	arc=none smtp.remote-ip=198.54.127.149
Received: from out-2z4y-a149.jellyfish.systems (out-2z4y-a149.jellyfish.systems [198.54.127.149])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A0B606A31C
	for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 12:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91A0B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tychen.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tychen.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tychen.cc header.i=@tychen.cc header.a=rsa-sha256 header.s=spacemail header.b=Ww942AoB
Received: from fedora (ec2-52-197-241-54.ap-northeast-1.compute.amazonaws.com [52.197.241.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4jbXRY1Nr7z2x99;
	Fri, 27 Nov 2026 12:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1795781709;
	bh=aTabeef5xq+0WitgzWBj+jPPdEI37fOW2SVHdZQA62A=;
	h=From:To:Cc:Subject:Date:From;
	b=Ww942AoB26H7g81S3we82us9KxixwMU73e6Swm5I37owENGUlDSmz9/haUjwXPfJB
	 FCuk8x6nICCPD8PDAdxi2D89GUpDiiVqjFw5vhhE5pdvNqsyr/SxkXcll0jwAd8YIQ
	 OfpHhzUz5t7bsymg2ni2dHMApRo+6D6uj3pIPGIFN4QQz72wg9scUaigY7X6dkgm/l
	 nC3vxqt6tGD+uXxm8XH/o9wH45hp/SXuOBVhj/GfaRdJ1O2opQCGuBMDK8b2ih7KpB
	 nZNKqETH4B+3p0C+Rbrh4gAljnARWw+rNMuDkp4SGVoksjYaeuHS1E6WHrFnoNDbua
	 AxbDSZ2UcFI7Q==
From: Tianyi Chen <hi@tychen.cc>
To: David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Cc: Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <tom.leiming@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Mark Korenberg <socketpair@gmail.com>,
	linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	hi@tychen.cc
Subject: btrfs, blk-throttle: cross-subvolume fsync stalls behind throttled write_dev_flush()
Date: Fri, 27 Nov 2026 21:14:58 +0900
Message-ID: <20261127121458.2090454-1-hi@tychen.cc>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc

Hi David, Qu, Tejun, Josef,

On f47d223627f8 (post-v7.3; write_dev_flush() and __blk_throtl_bio()
are unchanged on current mainline), an unthrottled cgroup doing fsync()
on one Btrfs subvolume can stall for 200-300 ms behind a sibling
subvolume cgroup capped with io.max wbps. Putting the two workloads on
separate Btrfs filesystems on the same parent disk avoids the stall.

In traced 2-vCPU KVM runs, cgroup A ran 100 Hz SQLite WAL
(synchronous=FULL) or LMDB commits on subvolume lc (io.max=max) while
cgroup B wrote and fsynced 64 KiB files in 1 MiB batches on subvolume
be (wbps=2097152). Every >50 ms foreground commit (18/18 WAL, 18/18
LMDB) slept in wait_log_commit() on the shared log_root_tree commit
while B was in:

  btrfs_sync_log() -> write_all_supers() -> barrier_all_devices()
    -> write_dev_flush()

When write_dev_flush() submitted its 0-byte REQ_OP_WRITE | REQ_SYNC |
REQ_PREFLUSH bio, B's blk-throttle queues were empty, but B had just
dispatched REQ_META tree-log writes (825-45,880 bytes over its slice
budget), so tg_within_bps_limit() queued the untagged 0-byte preflush
for 67-112 ms. Right after barrier_all_devices(), write_dev_supers()
submits the superblock write with REQ_OP_WRITE | REQ_SYNC | REQ_META |
REQ_PRIO.

Commits 29390bb5661d ("blk-throttle: support prioritized processing of
metadata") and a9fc8868b350 ("blk-throttle: don't take carryover for
prioritized processing of metadata") dispatch over-limit REQ_META bios
via bio_issue_as_root_blkg() and charge debt back without trimming the
slice. On the other hand, Mark Korenberg's recent REQ_META audit [1]
deliberately left write_dev_flush() untagged because the empty preflush
covers the whole device cache.

In the same thread Qu argued that background work such as scrub
should not get the priority of metadata I/O [2], and v2 dropped those
paths [3]. This flush is not background work: write_all_supers()
issues it on every log or transaction commit, right before the
superblock write that already carries REQ_META | REQ_PRIO.

To measure both sides of that choice, I tested this one-line change to
the bio_init() flags in write_dev_flush():

  -  REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH
  +  REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO | REQ_PREFLUSH

I ran 5 interleaved 2-vCPU KVM pairs (10 fresh boots, fresh Btrfs per
cell, trace off) with B capped at wbps=2097152 in every row. Over the
active window [1s, 4s) of a 6s run, response = completion -
scheduled_offer and service = completion - actual_start. "fixed WAL"
reuses a pre-grown WAL with wal_autocheckpoint=0, DELETE is SQLite's
rollback journal, and splitfs puts A and B on separate Btrfs
filesystems on the same disk. "(lower)" counts pairs with a lower p95
on the patched kernel; ">50 sum" counts services over 50 ms in all 5
pairs:

  stock -> patched (ms)     resp p95 med (lower)   resp p99 med    >50 sum
  two_subvol, SQLite WAL    227.43 ->  3.51 (5/5)  305.62 ->  4.80   34->0
  two_subvol, fixed WAL     255.55 ->  3.43 (5/5)  302.95 ->  4.95   61->0
  two_subvol, DELETE 25Hz   238.25 -> 12.62 (5/5)  313.00 -> 13.72   25->1
  two_subvol, DELETE 100Hz  1044.4 -> 38.53 (5/5)  1074.5 -> 72.31   55->5
  two_subvol, LMDB          182.72 -> 11.06 (4/5)  247.28 -> 46.97   19->6
  splitfs, SQLite WAL         3.50 ->  3.29 (4/5)    4.09 ->  4.03    0->0

In separate traced runs, all 68 background empty barriers per cell
still issued and completed (0/68 queued in blk-throttle vs 4/68 for
WAL and 4/67 for LMDB on stock), and max foreground wait_log_commit()
time on log_root_tree fell from 105.6 -> 2.9 ms (WAL) and
104.6 -> 1.9 ms (LMDB).

At the same time, tagging write_dev_flush() is not free everywhere:

- On LMDB (wbps=2M), service p95 was lower in only 1/5 pairs (7.32 ->
  8.21 ms median; metadata space-reservation waits up to 56.7 ms
  remain), and B's batches finished later in 4/5 pairs (+99.2 ms median
  paired delta). With no background writer, WAL response p95 was
  slightly higher in 4/5 pairs (+0.30 ms median paired delta).
- Adding io.latency (target=10000 on A) to the same wbps cap on stock
  did not avoid the stall: it remained in 4/5 pairs for both engines.
  The 1-line change alone was lower than stock + io.latency in those
  4/5 pairs, and worse in the remaining one (p95 3.59 -> 4.12 ms WAL,
  6.76 -> 37.14 ms LMDB).
- Quota checks (one pair each): 4x1 MiB writes + fsync under wbps=2M
  did not finish early (2.06 s -> 2.12 s). Two IOPS-capped runs issued
  the same 224 device writes and 64 flushes on both kernels but
  finished sooner: 32 paced single-page overwrites + fsync (one op in
  flight) under wiops=16 in 11.11 s -> 10.81 s (+2.7% device
  write/flush rate), and 32 alternating 64 KiB / 4 KiB writes + fsync
  under a two-level cap (leaf wbps=2M wiops=48, parent wbps=3M
  wiops=128) in 3.91 s -> 3.71 s (+5.4%). I did not trace where the
  difference comes from, and an unpaced fsync loop under wiops was not
  tested.

Should write_dev_flush() stay untagged because the cache flush is
device-wide, or is avoiding the log_root_tree / write_all_supers()
priority inversion worth tagging it REQ_META (or handling a 0-byte
REQ_PREFLUSH against existing byte debt differently in blk-throttle)?

[1] https://lore.kernel.org/linux-btrfs/20261104-btrfs-sb-read-req-meta-v1-1-e06b4d059897@gmail.com/
[2] https://lore.kernel.org/linux-btrfs/c2166059-7964-4f1f-b87a-2798c96a2db9@gmx.com/
[3] https://lore.kernel.org/linux-btrfs/20261106-btrfs-sb-read-req-meta-v2-0-71c1afaf5c67@gmail.com/

A standalone Python reproducer is below. Run it as root in a disposable
VM with one scratch block device (or two partitions on the same disk to
include the splitfs control).

Thanks,
Tianyi

Assisted-by: LLM

---8<---
#!/usr/bin/env python3
"""Reproduce Btrfs cross-subvolume fsync stalls under cgroup2 io.max wbps.

Run inside a disposable root VM on scratch block device(s) TO BE WIPED:
  python3 btrfs-subvol-flush-repro.py --wipe /dev/vde
  python3 btrfs-subvol-flush-repro.py --wipe /dev/vde1 /dev/vde2
"""
import argparse, json, math, os, shutil, sqlite3, stat
import subprocess as sp, sys, tempfile, time
from pathlib import Path


def put(p, s):
    Path(p).write_text(str(s))


def run(cmd):
    sp.run([str(x) for x in cmd], check=True, stdout=sp.DEVNULL)


def sleep_until(ns):
    while (d := (ns - time.monotonic_ns()) / 1e9) > 0:
        time.sleep(d)


def parent_devnum(dev):
    st = os.stat(dev)
    assert stat.S_ISBLK(st.st_mode), f"not a block device: {dev}"
    maj, mn = os.major(st.st_rdev), os.minor(st.st_rdev)
    sysfs = Path(f"/sys/dev/block/{maj}:{mn}").resolve()
    if (sysfs / "partition").exists():
        sysfs = sysfs.parent
    return (sysfs / "dev").read_text().strip()


def worker_lc(cg, ddir):
    put(Path(cg) / "cgroup.procs", os.getpid())
    db = sqlite3.connect(Path(ddir) / "lc.db", isolation_level=None,
                         timeout=30)
    for pragma in ("page_size=4096", "journal_mode=WAL",
                   "synchronous=FULL", "cache_size=128"):
        db.execute("PRAGMA " + pragma)
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v INT, pad BLOB)")
    db.execute("BEGIN")
    rows = [(i,) for i in range(256)]
    db.executemany("INSERT INTO t VALUES(?, 0, zeroblob(3500))", rows)
    db.execute("COMMIT")
    db.execute("PRAGMA wal_checkpoint(TRUNCATE)").fetchall()
    print("ready", flush=True)
    t0 = int(sys.stdin.readline())
    out = []
    for i in range(600):
        due = i * 10_000_000
        sleep_until(t0 + due)
        a = time.monotonic_ns()
        db.execute("BEGIN IMMEDIATE")
        db.execute("UPDATE t SET v=v+1 WHERE id=?", (i % 256,))
        db.execute("COMMIT")
        b = time.monotonic_ns()
        if 100 <= i < 400:
            out.append(((b - (t0 + due)) / 1e6, (b - a) / 1e6))
    db.close()
    print(json.dumps(out), flush=True)


def worker_be(cg, ddir, active):
    put(Path(cg) / "cgroup.procs", os.getpid())
    buf = b"B" * 65536
    print("ready", flush=True)
    t0 = int(sys.stdin.readline())
    batches = 0
    while active and batches < 64:
        sleep_until(t0 + 1_000_000_000 + batches * 62_500_000)
        if time.monotonic_ns() >= t0 + 4_000_000_000:
            break
        for f in range(16):
            p = Path(ddir) / f"b{batches}_{f}"
            flags = os.O_CREAT | os.O_EXCL | os.O_WRONLY
            fd = os.open(p, flags, 0o600)
            try:
                assert os.write(fd, buf) == len(buf)
                os.fsync(fd)
            finally:
                os.close(fd)
        dfd = os.open(ddir, os.O_RDONLY | os.O_DIRECTORY)
        try:
            os.fsync(dfd)
        finally:
            os.close(dfd)
        batches += 1
    print(json.dumps(batches), flush=True)


def pct(vals, q):
    s = sorted(vals)
    return s[math.ceil(q * len(s)) - 1]


def run_case(name, devs, splitfs, throttled, cg_root, tmp):
    m1, m2 = Path(tmp) / "m1", Path(tmp) / "m2"
    m1.mkdir(exist_ok=True)
    m2.mkdir(exist_ok=True)
    cglc, cgbe = cg_root / "lc", cg_root / "be"
    cglc.mkdir()
    cgbe.mkdir()
    mounted = []
    procs = []
    try:
        run(["mkfs.btrfs", "-q", "-f", devs[0]])
        run(["mount", "-t", "btrfs", devs[0], m1])
        mounted.append(m1)
        if splitfs:
            run(["mkfs.btrfs", "-q", "-f", devs[1]])
            run(["mount", "-t", "btrfs", devs[1], m2])
            mounted.append(m2)
            lcp, bep = m1 / "lc", m2 / "be"
            lcp.mkdir()
            bep.mkdir()
        else:
            lcp, bep = m1 / "lc", m1 / "be"
            run(["btrfs", "subvolume", "create", lcp])
            run(["btrfs", "subvolume", "create", bep])
        if throttled:
            pdev = parent_devnum(devs[1 if splitfs else 0])
            put(cgbe / "io.max", f"{pdev} wbps=2097152")
        run(["sync"])
        cmd_lc = [sys.executable, __file__, "_lc", str(cglc), str(lcp)]
        cmd_be = [sys.executable, __file__, "_be", str(cgbe), str(bep),
                  str(int(throttled))]
        plc = sp.Popen(cmd_lc, stdin=sp.PIPE, stdout=sp.PIPE, text=True)
        pbe = sp.Popen(cmd_be, stdin=sp.PIPE, stdout=sp.PIPE, text=True)
        procs = [plc, pbe]
        assert plc.stdout.readline().strip() == "ready"
        assert pbe.stdout.readline().strip() == "ready"
        t0 = time.monotonic_ns() + 200_000_000
        for p in procs:
            p.stdin.write(f"{t0}\n")
            p.stdin.flush()
        pairs = json.loads(plc.stdout.readline())
        batches = json.loads(pbe.stdout.readline())
        assert plc.wait(timeout=10) == 0 and pbe.wait(timeout=10) == 0
        resps = [r for r, _ in pairs]
        svcs = [s for _, s in pairs]
        gt50 = sum(s > 50 for s in svcs)
        print(f"{name:19s} n={len(pairs)} resp_p95={pct(resps, 0.95):6.2f}ms"
              f" resp_p99={pct(resps, 0.99):6.2f}ms svc>50ms={gt50:2d}"
              f" be_batches={batches}", flush=True)
    finally:
        for p in procs:
            if p.poll() is None:
                p.kill()
                p.wait()
        run(["sync"])
        for m in reversed(mounted):
            sp.run(["umount", str(m)], check=False)
        for c in (cglc, cgbe):
            if c.exists():
                c.rmdir()


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "_lc":
        return worker_lc(sys.argv[2], sys.argv[3])
    if len(sys.argv) > 1 and sys.argv[1] == "_be":
        return worker_be(sys.argv[2], sys.argv[3], bool(int(sys.argv[4])))
    ap = argparse.ArgumentParser()
    ap.add_argument("--wipe", action="store_true", required=True,
                    help="confirm wiping target scratch block device(s)")
    ap.add_argument("devs", nargs="+",
                    help="one scratch disk, or two same-disk partitions")
    args = ap.parse_args()
    assert os.geteuid() == 0 and 1 <= len(args.devs) <= 2
    if len(args.devs) == 2:
        assert parent_devnum(args.devs[0]) == parent_devnum(args.devs[1])
    put("/sys/fs/cgroup/cgroup.subtree_control", "+io")
    cg_root = Path(f"/sys/fs/cgroup/btrfs_repro_{os.getpid()}")
    cg_root.mkdir()
    put(cg_root / "cgroup.subtree_control", "+io")
    print(f"kernel={os.uname().release}", flush=True)
    with tempfile.TemporaryDirectory() as tmp:
        try:
            run_case("two_subvol_absent", args.devs, False, False,
                     cg_root, tmp)
            if len(args.devs) == 2:
                run_case("splitfs_wbps2m", args.devs, True, True,
                         cg_root, tmp)
            run_case("two_subvol_wbps2m", args.devs, False, True,
                     cg_root, tmp)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)
            if cg_root.exists():
                cg_root.rmdir()


if __name__ == "__main__":
    main()
