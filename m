From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Tue, 6 Jun 2023 09:58:37 -1000
Message-ID: <ZH-P7X_yjnVfhy7b@slm.duckdns.org>
References: <deb7b684-3d7c-b3ae-7b36-5b7ba2dd8001@redhat.com>
 <ZFUo5IYAIwTEKR4_@slm.duckdns.org>
 <759603dd-7538-54ad-e63d-bb827b618ae3@redhat.com>
 <405b2805-538c-790b-5bf8-e90d3660f116@redhat.com>
 <ZGvHUjOCjwat91Gq@slm.duckdns.org>
 <18793f4a-fd39-2e71-0b77-856afb01547b@redhat.com>
 <ZH4jfmypOXGJPu0D@slm.duckdns.org>
 <be64a569-4388-9dd9-3e06-36d716a54f6c@redhat.com>
 <ZH5FNc6wjlGPsaaO@slm.duckdns.org>
 <a2220c9f-7a8d-da82-ecc0-b39f3807408c@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686081519; x=1688673519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9fzXlbPINbB7MLh0jxJ+Y5UChf2gkHO8C34dmKugRUg=;
        b=S03UnzPuSlaqndpGm3fYnzSEuVrAJXVaDyv5zhRB0i5qOf5lMwHRzbOjDYKhZQ3YSo
         K6JFXzTmnc5Eo0jMOnKFw9HQej3OKTiE/yaKVmk6JZ6cXrcoQ9HDNrj6Ulu/ThSN+8zH
         XELNofQ9A4CjY/LWiTTYEyPJ0ej0qw0h/zran7xqQiuRfvTLultwGtjYlcq8sS4ed+sK
         8hQjSnUD1/E3QK+CRaXt8pS2dKD7rK+nMC/dWUUVKcU5y9DBDO6YlOV/O/PkkLmBRN4X
         sBGC4cB3XiFMOmPvIfiknCyFlxijBSnkSJdGYSFYSDsdnyHBdclop9rTWD/UjH1tKS26
         2GMA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a2220c9f-7a8d-da82-ecc0-b39f3807408c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mrunal Patel <mpatel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Phillips <rphillips-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brent Rowsell <browsell-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Hunt <pehunt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Waiman.

On Mon, Jun 05, 2023 at 10:47:08PM -0400, Waiman Long wrote:
...
> I had a different idea on the semantics of the cpuset.cpus.exclusive at the
> beginning. My original thinking is that it was the actual exclusive CPUs
> that are allocated to the cgroup. Now if we treat this as a hint of what
> exclusive CPUs should be used and it becomes valid only if the cgroup can

I wouldn't call it a hint. It's still hard allocation of the CPUs to the
cgroups that own them. Setting up a partition requires exclusive CPUs and
thus would depend on exclusive allocations set up accordingly.

> become a valid partition. I can see it as a value that can be hierarchically
> set throughout the whole cpuset hierarchy.
> 
> So a transition to a valid partition is possible iff
> 
> 1) cpuset.cpus.exclusive is a subset of cpuset.cpus and is a subset of
> cpuset.cpus.exclusive of all its ancestors.

Yes.

> 2) If its parent is not a partition root, none of the CPUs in
> cpuset.cpus.exclusive are currently allocated to other partitions. This the

Not just that, the CPUs aren't available to cgroups which don't have them
set in the .exclusive file. IOW, if a CPU is in cpus.exclusive of some
cgroups, it shouldn't appear in cpus.effective of cgroups which don't have
the CPU in their cpus.exclusive.

So, .exclusive explicitly establishes exclusive ownership of CPUs and
partitions depend on that with an implicit "turn CPUs exclusive" behavior in
case the parent is a partition root for backward compatibility.

> same remote partition concept in my v2 patch. If its parent is a partition
> root, part of its exclusive CPUs will be distributed to this child partition
> like the current behavior of cpuset partition.

Yes, similar in a sense. Please do away with the "once .reserve is used, the
behavior is switched" part. Instead, it can be sth like "if the parent is a
partition root, cpuset implicitly tries to set all CPUs in its cpus file in
its cpus.exclusive file" so that user-visible behavior stays unchanged
depending on past history.

Thanks.

-- 
tejun
