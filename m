From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH-block v2 2/3] blk-cgroup: Don't flush a blkg if destroyed
Date: Mon, 12 Dec 2022 09:58:27 -0500
Message-ID: <ac3ec28b-929d-59e3-49c3-f7a548b01ebe@redhat.com>
References: <20221211222058.2946830-1-longman@redhat.com>
 <20221211222058.2946830-3-longman@redhat.com>
 <20221212125953.GE16456@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670857117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GkbQCXweWiVyxQliOP1BrMo+NMG+D0texQS/7HCzGIk=;
        b=OVbyBpYdn3v1uk5ECkg/XI4Sg8cAxQlpWQdTGJuFwKrvlJVouC2ucYJrUK2sGYDDoWt4Za
        5NyzzGx2/Bey3n3+54Bil6F7V9J/0JpL6Vxu0jyYUOW1sOPfP+eHZgSjXtouB5effzR5Y5
        IpFzA3xRXemx//WVC0YA5EmVAFREZI0=
Content-Language: en-US
In-Reply-To: <20221212125953.GE16456@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>


On 12/12/22 07:59, Michal Koutn=C3=BD wrote:
> Hello.
>
> On Sun, Dec 11, 2022 at 05:20:57PM -0500, Waiman Long <longman@redhat.com=
> wrote:
>> Before commit 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()"),
>> blkg's stats is only flushed if they are online.
> I'm not sure I follow -- css_release_work_fn/cgroup_rstat_flush may be
> called on an offlined blkcg (offlined!=3Dreleased). There's no invariant
> ensuring offlined blkcg won't be flushed. (There is only current
> situation when there is no reader of io data that'd need them flushed
> [1].)
The original cgroup_rstat_flush() iterates the list of blkg's in the=20
blkg_list. A blkg will be removed from the list when it is offlined.=20
This patch just reverts its behavior to that previous behavior.
>
>> In addition, the stat flushing of blkgs in blkcg_rstat_flush()
>> includes propagating the rstat data to its parent. However, if a blkg
>> has been destroyed (offline), the validity of its parent may be
>> questionable.
> Parents won't be freed (neither offlined) before children (see
> css_killed_work_fn). It should be regularly OK to pass data into a
> parent of an offlined blkcg.
I guess it is likely to be safe to flush an offline blkg. I am just=20
being conservative in case there is any corner case where it may be a=20
problem which I haven't foreseen.
>
>> For safety, revert back to the old behavior by ignoring offline
>> blkg's.
> I don't know if this is a good reasoning. If you argue that offlined
> children needn't be taken into parent's account, then I think it's more
> efficient to exclude the offlined blkcgs from update. (With the caveat I
> have in [1].)

It is possible that a blkg may be updated before it becomes offline, but=20
the flush isn't done in time before that happens. The next patch will=20
catch some of that.

Cheers,
Longman

