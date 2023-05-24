From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] blk-cgroup: Flush stats before releasing blkcg_gq
Date: Wed, 24 May 2023 00:10:55 -0400
Message-ID: <cfef97ec-bb77-4ccb-a0b2-8f1eb66afeb6@redhat.com>
References: <20230524011935.719659-1-ming.lei@redhat.com>
 <CAJD7tkZkbro4H-QC=RJx_dfCdGQ5c=4NJhbFrcEmQSidaaMOmg@mail.gmail.com>
 <ZG14VnHl20lt9jLc@ovpn-8-17.pek2.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684901459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+jjXC8nEHxswkc61Y0uyyoGWYpO1Pad3VdwaQeUusRw=;
        b=Z/1lLEL4bHQc1bXDWh3DKM4Duq/gTAbMPIUaK3KPNfJQY2w+CsGMzDPXZKOCssS2E6vaGV
        cEuhOcAiG6kJ8jB88qciZXa/PGKGT8UslfTa5/CYdbHx409zpUA6Qu75ZrriXtzWL505CO
        B4vFRAMbgkmXl6HURcHEHOu7wNRD0mc=
Content-Language: en-US
In-Reply-To: <ZG14VnHl20lt9jLc@ovpn-8-17.pek2.redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Ming Lei <ming.lei@redhat.com>, Yosry Ahmed <yosryahmed@google.com>
Cc: Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, mkoutny@suse.com


On 5/23/23 22:37, Ming Lei wrote:
> Hi Yosry,
>
> On Tue, May 23, 2023 at 07:06:38PM -0700, Yosry Ahmed wrote:
>> Hi Ming,
>>
>> On Tue, May 23, 2023 at 6:21=E2=80=AFPM Ming Lei <ming.lei@redhat.com> w=
rote:
>>> As noted by Michal, the blkg_iostat_set's in the lockless list
>>> hold reference to blkg's to protect against their removal. Those
>>> blkg's hold reference to blkcg. When a cgroup is being destroyed,
>>> cgroup_rstat_flush() is only called at css_release_work_fn() which
>>> is called when the blkcg reference count reaches 0. This circular
>>> dependency will prevent blkcg and some blkgs from being freed after
>>> they are made offline.
>> I am not at all familiar with blkcg, but does calling
>> cgroup_rstat_flush() in offline_css() fix the problem?
> Except for offline, this list needs to be flushed after the associated di=
sk
> is deleted.
>
>> or can items be
>> added to the lockless list(s) after the blkcg is offlined?
> Yeah.
>
> percpu_ref_*get(&blkg->refcnt) still can succeed after the percpu refcnt
> is killed in blkg_destroy() which is called from both offline css and
> removing disk.

As suggested by Tejun, we can use percpu_ref_tryget(&blkg->refcnt) to=20
make sure that we can only take a reference when the blkg is online. I=20
think it is a bit safer to take a percpu refcnt to avoid use after free.=20
My other concern about your patch is that the per cpu list iterations=20
will be done multiple times when a blkcg is destroyed if many blkgs are=20
attached to the blkcg. I still prefer to do it once in=20
blkcg_destroy_blkgs(). I am going to post an updated version tomorrow=20
after some more testings.

Cheers,
Longman

