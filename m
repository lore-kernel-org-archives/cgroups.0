From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-block v2 2/3] blk-cgroup: Don't flush a blkg if destroyed
Date: Mon, 12 Dec 2022 19:21:40 -0500
Message-ID: <1fe8b5b3-c066-649b-fa4a-07d67ed7eb17@redhat.com>
References: <20221211222058.2946830-1-longman@redhat.com>
 <20221211222058.2946830-3-longman@redhat.com>
 <20221212125953.GE16456@blackbody.suse.cz> <Y5eoQ8UBN8Xpc+Wp@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670890910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XSSw4rDrHdkebs9yVeYoOqKNZTGifGu/wo1Yfh7rryY=;
        b=LpnkpXwiA6lo5Rx29Ts9A9UcJB+WbCqonBpKaI0fFkICcPGppOdnU7SnCTV3UF3Aiv1AH+
        F5Lu1e6JEoaKeJo6f9NBgATxf1gmmKBpfTIq4uHFzjbz4j0s9LSq95pvPhp7Ticm2MdzWp
        +LO8z2SCe7zYbFGr7jE06ooQWLHxmj0=
Content-Language: en-US
In-Reply-To: <Y5eoQ8UBN8Xpc+Wp-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 12/12/22 17:16, Tejun Heo wrote:
> On Mon, Dec 12, 2022 at 01:59:53PM +0100, Michal Koutn=C3=BD wrote:
>> Hello.
>>
>> On Sun, Dec 11, 2022 at 05:20:57PM -0500, Waiman Long <longman-H+wXaHxf7=
aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> Before commit 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()"),
>>> blkg's stats is only flushed if they are online.
>> I'm not sure I follow -- css_release_work_fn/cgroup_rstat_flush may be
>> called on an offlined blkcg (offlined!=3Dreleased). There's no invariant
>> ensuring offlined blkcg won't be flushed. (There is only current
>> situation when there is no reader of io data that'd need them flushed
>> [1].)
>>
>>> In addition, the stat flushing of blkgs in blkcg_rstat_flush()
>>> includes propagating the rstat data to its parent. However, if a blkg
>>> has been destroyed (offline), the validity of its parent may be
>>> questionable.
>> Parents won't be freed (neither offlined) before children (see
>> css_killed_work_fn). It should be regularly OK to pass data into a
>> parent of an offlined blkcg.
>>
>>> For safety, revert back to the old behavior by ignoring offline
>>> blkg's.
>> I don't know if this is a good reasoning. If you argue that offlined
>> children needn't be taken into parent's account, then I think it's more
>> efficient to exclude the offlined blkcgs from update. (With the caveat I
>> have in [1].)
> Yeah, I'm not sure about this patch either. Doesn't seem necessary.

I wrote this patch because I am not totally sure it is safe to flush=20
offline blkgs. Since both you and Michal don't see any problem with it.=20
I am fine taking it out.

Cheers,
Longman

