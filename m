From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 8/9] cgroup/cpuset: Documentation update for partition
Date: Mon, 10 Jul 2023 15:07:11 -1000
Message-ID: <ZKyrP74UzVb4Ltwi@slm.duckdns.org>
References: <20230627143508.1576882-1-longman@redhat.com>
 <20230627143508.1576882-9-longman@redhat.com>
 <ZKx4ZJowRhRtjZxB@slm.duckdns.org>
 <6d5aee58-f558-868c-76e0-0b58f8332110@redhat.com>
 <ZKyljsbJgLNpsBLI@slm.duckdns.org>
 <a429e60a-fc4f-60b0-3978-71596fed9542@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689037633; x=1691629633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IxBIJVCy8BSte3A+R6dkOVqHWVmw7XdfvWAKQ51rWXE=;
        b=iUPgdvmc76GAhsSeiyKt1afxZwczuvHmWhxciN5pTKOMxs8Y6qHZv4aZJbyiAzs3MD
         RpkVN7uTX+lmBkUSEyYUbdaVf1vk0iM3HfaqNO4w/1mNhQKjaqiwLi/4PyhJwpHBJIuw
         T0wCBhqgpCS3FVuvNRx1TMtnTitnxGOe6tsgtvkwFNxWh4qdRlW98ezZ3UUnz2VRikUG
         2Y0UIlrr3dF5gX8jbIozxxXvoqmlZj6F0X0FFA7yipiYTTgK78q7cTJmoXfWGkQ8DAZg
         shoKh0pYE4emU7FwZD909nkygrIJ/F72a3z6F+k3Nds1p0lLqUs25ELUCUVpRxdPUk2D
         sEGw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a429e60a-fc4f-60b0-3978-71596fed9542-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mrunal Patel <mpatel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Phillips <rphillips-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brent Rowsell <browsell-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Hunt <pehunt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Mon, Jul 10, 2023 at 08:53:18PM -0400, Waiman Long wrote:
> For local partition, it doesn't make sense to have a cpust.cpus.exclusive
> that is not the same as cpuset.cpus as it artificially reduce the set of
> CPUs that can be used in a partition. In the case of a remote partition, the

Yeah, I was wondering about local partitions. "Automatic but can be
overridden" behavior becomes confusing if it's difficult for the user to
easily tell which part is automatic when. I wonder whether it'd be better to
make the condition static - e.g. for a partition cgroup, cpus.exclusive
always contains all bits in cpus no matter what value is written to it. Or,
if we separate out cpus.exclusive and cpus.exclusive.effective, no matter
what cpus.exclusive is set, a partition root's cpus.exclusive.effective
always includes all bits in cpus.effective.

Thanks.

-- 
tejun
