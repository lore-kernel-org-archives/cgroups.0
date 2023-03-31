From: Tyler Rider <tylerjrider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: freezer cgroups: Forcing frozen memory to swap
Date: Fri, 31 Mar 2023 11:49:30 -0700
Message-ID: <CAEeXeQLTQjt6O4C-_3dE63gPEgXU9qtdM2+XDxYemV9bsfq_pg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680288581;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZOhzycB/ed1Cglv3QcQsbmP+PbGJbFYnPnJg8JQRNCg=;
        b=NY4ov3CyjrOGkt3nlM7tThCPwwisGqA9MCueHcb0ox57tn+8OI0jjTFbQ2xNZ0d7U6
         hO6TxL/1I1u8AloYj4zSghmf37darJkgVOGSqlQnDBlMfoJHZliIPNtrCDUlLOeySBEI
         AnsZg2vZ/5CxjsE3LU2AXXHRYU+PHbcNYG1Fatxaqb/7RJ4SfjIbz5yH/Flqf62CNP0H
         yuQHhxms90q//FVf9lGMNcWyPLMDNrYwD2ehzMFNAlZB5GleLTBI4ibKU1ip7kVS0VQg
         zCc14QL5hOvVUiBNbD5PHRSBAMq052WLRCh4ly14jBfSZXUP315widwGI3o9zNOfhu4A
         Cevw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

I've been trying to search for some mechanism(s) to reclaim resident
memory of some frozen applications on a small embedded device. The
typical use case is to bring up an app and once backgrounded/dismissed
the idea is to freeze/thaw for faster resume/restart times.

The issue is that after starting/pausing several of these applications
(and subsequently freezing) memory begins dropping, and memory
thrashing begins. (I can stop the apps of course, but then that leads
to longer load times).

I've already got memory constraint issues, which led to adding a swap
partition. I've tried bumping the memory.swapiness to 100 within a
memory cgroup, and waiting a few seconds for kswapd to kick in before
freezing but since the app is running it only puts a handful of pages
into swap.

Some projects exist (crypopid(2) / CRIU) for dumping the process state
in userspace, but unless I'm missing something, I'd imagine there must
be some existing kernel mechanism (seems like a useful feature for
small memory constrained devices) within the freezer/memory cgroups
that can force all pages of the frozen process to a swap partition,
and restore on thaw.

Does this sort of  cgroup-level S4 (hibernate-to-disk) exist or even
just a mechanism to force a frozen process's pages to swap?

Thanks,
Tyler
