From: Philipp Hahn <pmhahn+lkml@pmhahn.de>
Subject: Prevent inode/dentry trashing?
Date: Mon, 7 Jun 2021 14:39:35 +0200
Message-ID: <ce330972-78e6-4347-9735-72ee7bb21ef5@pmhahn.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pmhahn.de; s=202002;
        t=1623069575; bh=BBOoFi9HzmEh7B1OpgYxyXy8hseIid57bVC7FAkBMWE=;
        h=To:From:Subject:Date:From;
        b=IldtndQH66LqgCtd1zYeQWCI5owbGkaqz8YMfWxhDaLSL9HvYI8OxYSPuII/RAia5
         YkTmp++EEFouXzNPMMlADn7E86uh3DgLlSl0rad9YToXrUPd0FbK2FrDlUwyfiJokr
         5lq+i/KM2mEZR9X9JGPISmN6UJvWOs99fJpZwS+Vym0Z+BdHtcRjFJQ5YGnNTplBL/
         R6KAbi+hpFei/a9uoV5GCYC7CfaKRoQ6zahgN+RvoZHEbMB6lkWk/TfSIfHL3XsVHl
         0O4xZBMRRZ3lw2xy/0Jp/GXYFb/idwZdV908N1b6kxpikUS/ZOQLRfukW1NrLnyk8y
         m7o9ODcFlrwyg==
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

Hello,

Similar to 
<https://unix.stackexchange.com/questions/202586/limit-the-inode-cache-used-by-a-command> 
I would like to prevent certain programs from trashing the inode/dentry 
cache, which is a shared resource for all processes:

- For example the nightly <man:updatedb(8)> used <man:find(1) > to 
recursively walk the complete file system. As long as `d_name` and the 
`d_type` information from <man:readdir(3)> is enough this only pollutes 
the dentry cache.

- Similar our backup software, but this also needs to <man:stat(2)> each 
path to get the `mtime`, which additionally pollutes the inode cache.

Both examples only walk the tree once (per day). In my case the caches 
do not fit into memory completely, so the second process does not even 
benefit from the first process filling the cache as that data is already 
replaced again.

The trashed caches affect all other processes running in parallel or the 
first processes started each morning.

Is it possible to prevent inode/dentry trashing for example by limiting 
the cache per process(-group)?
Something like MADV_DONTNEED from <man:madvise(2)> for IO would be nice.

An external knob to limit the cache usage per process(-group) would be 
nice, but even a hint for an API for such kind of programs to prevent 
trashing would help me.

Thank you in advance.
Philipp
