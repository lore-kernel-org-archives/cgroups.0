From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v8 2/4] mm, oom: cgroup-aware OOM killer
Date: Wed, 13 Sep 2017 14:59:57 -0700
Message-ID: <20170913215957.GB19259@castle>
References: <20170911131742.16482-1-guro@fb.com>
 <20170911131742.16482-3-guro@fb.com>
 <alpine.DEB.2.10.1709131346200.146292@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=/RR4RMQNHTyvEm1HtsO4N3RyCmEDpeTNIjVPhuzGbBQ=;
 b=f3o2zM7ad65MLO1qYr8y3TwBpmUEEnSxEqxTl1BAyEIzWKDqx0KbnzPVc2VpDtpfGpnp
 bCFTgQZRkFeY5DdgawKpAsncKhKgM/i7cFQypeuQT0Pk9i7sv5YClGs+80AKkUFNzrkF
 DUWgk3O0c+aWAM3f0zS15Edbpss9ZPXmoZ0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/RR4RMQNHTyvEm1HtsO4N3RyCmEDpeTNIjVPhuzGbBQ=;
 b=YtXZgI7tWdwBrnnqhWPJm6RO35/e49AjFm7YbqX93zwzoetUkyh1eVCgqDYmfEEdwBcyrQWUniZGTiU2IeBN8j12V5YuB7JtzvWMzJ+f1sl6pfhPhyDnrEdChZOZeYqjFU8sAjWXo6x7DKmqY92V9WHGDfDCs/RjFr5ESh2EZqM=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1709131346200.146292-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 13, 2017 at 01:46:51PM -0700, David Rientjes wrote:
> On Mon, 11 Sep 2017, Roman Gushchin wrote:
> 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 15af3da5af02..da2b12ea4667 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2661,6 +2661,231 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
> >  	return ret;
> >  }
> >  
> > +static long memcg_oom_badness(struct mem_cgroup *memcg,
> > +			      const nodemask_t *nodemask,
> > +			      unsigned long totalpages)
> > +{
> > +	long points = 0;
> > +	int nid;
> > +	pg_data_t *pgdat;
> > +
> > +	/*
> > +	 * We don't have necessary stats for the root memcg,
> > +	 * so we define it's oom_score as the maximum oom_score
> > +	 * of the belonging tasks.
> > +	 */
> > +	if (memcg == root_mem_cgroup) {
> > +		struct css_task_iter it;
> > +		struct task_struct *task;
> > +		long score, max_score = 0;
> > +
> > +		css_task_iter_start(&memcg->css, 0, &it);
> > +		while ((task = css_task_iter_next(&it))) {
> > +			score = oom_badness(task, memcg, nodemask,
> > +					    totalpages);
> > +			if (max_score > score)
> 
> score > max_score

Ups. Fixed. Thanks!
