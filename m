From: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: add sysctl to control global OOM logging behaviour
Date: Wed, 08 Nov 2017 15:19:50 +0300
Message-ID: <87inelklnd.fsf@openvz.org>
References: <20171108091843.29349-1-dmonakhov@openvz.org> <24fb6865-6cc5-2af0-3a99-ea9495791f66@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=CmtGXTrkeM06h7YWmleVvorN2NMOqP5ghKGqHCCvSgU=;
        b=a5ZYlt3q+9LDfv8MmdJ4GoTwMeOL/KOwRnmbpLmTZ0mV/gkAqa7+TBVhBTPgKs9Pl7
         mRNfnBRYriBfkAzOlwubgmwC5nH3VIGCPen9aZi63hwdLe2SjvB2hPdyjCALdYi+LmRy
         r0CFudfJIoR3WxKjPCFL9cmR73Ebv41eAFfqgmKTpAMNt3vCgLOXBg6h1N0d62ND2vN9
         IX61LaPWJAKXsRDsVPC5QN1LGrRUSTWJkI07dxwrJ8EB1+ma5cPRHxSBEtUvx2E0oboB
         0eMZNbmtQ6YtBjoub4F+QDLEUO06lPEsatMSkxgOXZiEETSdPj0nZ/Y3vFsfr+46qH4s
         6KSw==
In-Reply-To: <24fb6865-6cc5-2af0-3a99-ea9495791f66-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org> writes:

> On 2017/11/08 18:18, Dmitry Monakhov wrote:
>> Our systems becomes bigger and bigger, but OOM still happens.
>> This becomes serious problem for systems where OOM happens
>> frequently(containers, VM) because each OOM generate pressure
>> on dmesg log infrastructure. Let's allow system administrator
>> ability to tune OOM dump behaviour
>
> Majority of OOM killer related messages are from dump_header().
> Thus, allow tuning __ratelimit(&oom_rs) might make sense.
>
> But other lines
>
>   "%s: Kill process %d (%s) score %u or sacrifice child\n"
>   "Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n"
>   "oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n"
This still may result in hundreds of messages per second.
So it would be nice to have option to disable OOM logging.
> should not cause problems, for it is easy to exclude such lines from
> your dmesg log infrastructure using fgrep match.
In fact I've considered an abbility to use even more
fine grained log level control:
0: no oom log at all
1: dump only single line logs ( from oom_kill_process and reaper_task)
2: 1+ dump headers
3: 2+ task_stack (which previously controlled by sysctl_oom_dump_task)
What do you think?
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
