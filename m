From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: CLONE_INTO_CGROUP probably needs to call controller attach handlers
Date: Tue, 28 Mar 2023 17:39:43 +0200
Message-ID: <20230328153943.op62j3sw7qaixdsq@wittgenstein>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680017992;
        bh=bm2MrEPyszxRmD7eWeSEITojITTA3y9rSJopaZVgCJI=;
        h=Date:From:To:Cc:Subject:From;
        b=begcOk0DwzxGyVMLYF8bwQ+eCzvQnXEm8Jj0EsCUgDUd6VADHMrkE4JmDezxj6mW3
         iSy7A1uKgLiOMporYuaLWHCy2oHE/KhBBsFoDywqVQ14LvVm7Fywx45VPMRoPhTr4o
         oogaZbacKQnoG748LJG58XAM1ps0EEuZcOZomgXjt6pbvc/9TdpKBCtUuqdsxshhTx
         RxnEgFgIoLc5EfzVLUmiyELHH+7pZ/Pvcm5sil1NNouUpD/pHO/Xlj0dM0Yu4jjWmc
         /7gTw21ScGVCcV5EOVbr9LZXeFWN407R1kJdXnkFo7xfiGfChQ4Jbr10t88zqVQauS
         sWqNQPoGm6T+Q==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hey,

Giuseppe reported that the the affinity mask isn't updated when a
process is spawned directly into the target cgroup via
CLONE_INTO_CGROUP. However, migrating a process will cause the affinity
mask to be updated (see the repro at [1].

I took a quick look and the issue seems to be that we don't call the
various attach handlers during CLONE_INTO_CGROUP whereas we do for
migration. So the solution seems to roughly be that we need to call the
various attach handlers during CLONE_INTO_CGROUP as well when the
parent's cgroups is different from the child cgroup. I think we need to
call all of them, can, cancel and attach.

The plumbing here might be a bit intricate since the arguments that the
fork handlers take are different from the attach handlers.

Christian

[1]: https://paste.centos.org/view/f434fa1a


