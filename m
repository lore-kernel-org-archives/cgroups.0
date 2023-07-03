From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: update parent subparts cpumask while
 holding css refcnt
Date: Mon, 3 Jul 2023 09:18:54 -1000
Message-ID: <ZKMfHtY6zYFWvdqA@slm.duckdns.org>
References: <20230701065049.1758266-1-linmiaohe@huawei.com>
 <9244d968-b25a-066f-2ff3-1281bf03983e@redhat.com>
 <a6c55b82-71eb-ad18-e4b2-d62f1102a0e4@redhat.com>
 <53486caa-8ca7-78f5-71ac-d5692b482c94@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688411937; x=1691003937;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XLM8bt3vqZ21jspV7McGNog/5FNdcWiwVX6Q2kETF+w=;
        b=fUp8/gUM2xrq39W+clwmjDIYDsuV+SZhqcNG+rHtVRX2tfH41iYLXpznD8T4D3LlP+
         CIcoe+/xpdIEbFUCGm+70brdCsfacfSTyYM8SJuASzxma8g4ZZbVtN1cwysy8XlfiebM
         Cl+tGytgq2mJ5HObmp/lIiGcc9InwR8pdcXW9gkVgWYD+pXigazeoBmsdFMt0xOIGrjf
         +Y+4hWetaYbNk+llbwBKHyAb54yRyVDAF0APffUVdna6RS1vVuFrySrytVYYT0/rl/Vo
         gRufkceyPoNuelB1zZ+rNf9dxN8Zrqv8w/G8UQWZ1CjOezy/GsFN1Idn1pcYiBhiEl6R
         weyA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53486caa-8ca7-78f5-71ac-d5692b482c94-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Mon, Jul 03, 2023 at 10:58:19AM +0800, Miaohe Lin wrote:
> On 2023/7/2 7:46, Waiman Long wrote:
> > On 7/1/23 19:38, Waiman Long wrote:
> >> On 7/1/23 02:50, Miaohe Lin wrote:
> >>> update_parent_subparts_cpumask() is called outside RCU read-side crit=
ical
> >>> section without holding extra css refcnt of cp. In theroy, cp could be
> >>> freed at any time. Holding extra css refcnt to ensure cp is valid whi=
le
> >>> updating parent subparts cpumask.
> >>>
> >>> Fixes: d7c8142d5a55 ("cgroup/cpuset: Make partition invalid if cpumas=
k change violates exclusivity rule")
> >>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gm=
ane.org>
> >>> ---
> >>> =A0 kernel/cgroup/cpuset.c | 3 +++
> >>> =A0 1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> >>> index 58e6f18f01c1..632a9986d5de 100644
> >>> --- a/kernel/cgroup/cpuset.c
> >>> +++ b/kernel/cgroup/cpuset.c
> >>> @@ -1806,9 +1806,12 @@ static int update_cpumask(struct cpuset *cs, s=
truct cpuset *trialcs,
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 cpuset_for_each_child(cp, css, parent)
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (is_partition_valid(cp) &&
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cpumask_intersect=
s(trialcs->cpus_allowed, cp->cpus_allowed)) {
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!css_tryget_online=
(&cp->css))
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rcu_read_unlock();
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 update_parent_sub=
parts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rcu_read_lock();
> >>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 css_put(&cp->css);
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 rcu_read_unlock();
> >>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 retval =3D 0;
> >>
> >> Thanks for finding that. It looks good to me.
> >>
> >> Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.=
org>
> >=20
> > Though, I will say that an offline cpuset cannot be a valid partition r=
oot. So it is not really a problem. For correctness sake and consistency wi=
th other similar code, I am in favor of getting it merged.
>=20
> Yes, cpuset_mutex will prevent cpuset from being offline while update cpu=
mask. And as you mentioned, this patch makes code more consistency at least.

Can you update the patch description to note that this isn't required for
correctness?

Thanks.

--=20
tejun
