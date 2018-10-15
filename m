From: Tom Hromatka <tom.hromatka@oracle.com>
Subject: Re: [PATCH v13 03/11] cpuset: Simply allocation and freeing of
 cpumasks
Date: Mon, 15 Oct 2018 12:35:39 -0600
Message-ID: <fe132a9a-472d-22db-43ef-42c00b68c8dd@oracle.com>
References: <1539366951-8498-1-git-send-email-longman@redhat.com>
 <1539366951-8498-4-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=+l43h1IA0btkNct4kLOvCeqNoEw5BBbyqPrOu+U7Now=;
 b=mbQ8xNlt08uCfZkc9KbjBb2N7e+rHbnatkC7p9PFSeu8ewMxLH6Okr1hXCNp+Km0aGiX
 Me/5CtWFsXXDQo1t4QyRhMcJNsL0bsG40rOFjQL8wWQt2UlvNJvvZ/9R4605gxwBYnpL
 hWpPPu5u5d84GUDCHPVtFOygh/tqEBKs2fK6RDS5jYavg9/FubvJK+bGtp9CttDFjXQt
 WxuQkmuu2Slmqv/LmETeHi7JYMOkuZNKgr7knasDWDutibtH4Bk6IaqYJ6WU0fTC1Jah
 qmCzeNTHV0ARzo+waDZWLZ5D/yufuZYQ+ZPY3APc0S+KcYE4scm1To8rNGPjj0VDZp04 RQ== 
In-Reply-To: <1539366951-8498-4-git-send-email-longman@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>



On 10/12/2018 11:55 AM, Waiman Long wrote:
> The previous commit introduces a new subparts_cpus mask into the cpuset
> data structure and a new tmpmasks structure.  Managing the allocation
> and freeing of those cpumasks is becoming more complex.
>
> So a number of helper functions are added to simplify and streamline
> the management of those cpumasks. To make it simple, all the cpumasks
> are now pre-cleared on allocation.
>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>   kernel/cgroup/cpuset.c | 104 +++++++++++++++++++++++++++++++++---------=
-------
>   1 file changed, 71 insertions(+), 33 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 29a2bdc..9ac5f94 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -456,6 +456,57 @@ static int is_cpuset_subset(const struct cpuset *p, =
const struct cpuset *q)
>   }
>  =20
>   /**
> + * alloc_cpumasks - allocate three cpumasks for cpuset
> + * @cs:  the cpuset that have cpumasks to be allocated.
> + * @tmp: the tmpmasks structure pointer
> + * Return: 0 if successful, -ENOMEM otherwise.
> + *
> + * Only one of the two input arguments should be non-NULL.
> + */
> +static inline int alloc_cpumasks(struct cpuset *cs, struct tmpmasks *tmp)
> +{
> +	cpumask_var_t *pmask1, *pmask2, *pmask3;
> +
> +	if (cs) {
> +		pmask1 =3D &cs->cpus_allowed;
> +		pmask2 =3D &cs->effective_cpus;
> +		pmask3 =3D &cs->subparts_cpus;
> +	} else {
> +		pmask1 =3D &tmp->new_cpus;
> +		pmask2 =3D &tmp->addmask;
> +		pmask3 =3D &tmp->delmask;
> +	}
> +
> +	if (!zalloc_cpumask_var(pmask1, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	if (!zalloc_cpumask_var(pmask2, GFP_KERNEL))
> +		goto free_one;
> +
> +	if (!zalloc_cpumask_var(pmask3, GFP_KERNEL))
> +		goto free_two;
> +
> +	return 0;
> +
> +free_two:
> +	free_cpumask_var(*pmask2);
> +free_one:
> +	free_cpumask_var(*pmask1);
> +	return -ENOMEM;
> +}
> +
> +/**
> + * free_cpumasks - free cpumasks in a tmpmasks structure
> + * @tmp: the tmpmasks structure pointer
> + */
> +static inline void free_cpumasks(struct tmpmasks *tmp)
> +{
> +	free_cpumask_var(tmp->new_cpus);
> +	free_cpumask_var(tmp->addmask);
> +	free_cpumask_var(tmp->delmask);
> +}
> +

I hesitate to bring this up, but since you're respinning this
patch for a different bug...

Would it make sense to have free_cpumasks() have a similar
API and behavior to alloc_cpumasks()?=C2=A0 I could see this potentially
causing bugs/confusion in future patches.

Thanks.

Tom


