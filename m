From: Roman Gushchin <guro@fb.com>
Subject: Re: [patch -mm v2 2/3] mm, memcg: replace cgroup aware oom killer
 mount option with tunable
Date: Tue, 30 Jan 2018 12:13:22 +0000
Message-ID: <20180130121315.GA5888@castle.DHCP.thefacebook.com>
References: <20180125160016.30e019e546125bb13b5b6b4f@linux-foundation.org>
 <alpine.DEB.2.10.1801261415090.15318@chino.kir.corp.google.com>
 <20180126143950.719912507bd993d92188877f@linux-foundation.org>
 <alpine.DEB.2.10.1801261441340.20954@chino.kir.corp.google.com>
 <20180126161735.b999356fbe96c0acd33aaa66@linux-foundation.org>
 <20180129104657.GC21609@dhcp22.suse.cz>
 <20180129191139.GA1121507@devbig577.frc2.facebook.com>
 <20180130085445.GQ21609@dhcp22.suse.cz>
 <20180130115846.GA4720@castle.DHCP.thefacebook.com>
 <20180130120852.GA21609@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=f6GF0sKyLKCNjiT7A43BPOSDMYXncp2ParbRRu6C0cs=;
 b=MTNC5gryRcB27SZGWjERViAC9fzBtPfjemT/wz5d+xUpWrN62JvKIEkZZ36Zb3HhN4T7
 fF1I3EOUisWWdzxtegeTLJyVNjHBwKGs0gxppfE3Tdtg8qM7OjGqmgUrVuTOysN332pA
 uO76S/Ym+0z8roR9lVT9nDpSKbi6N+UaDKA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=f6GF0sKyLKCNjiT7A43BPOSDMYXncp2ParbRRu6C0cs=;
 b=XDzY+dhMuZc+XxTy8/jatGhgSZ9ImJ5EAp8Z6T1tQCy2ztWKKg4ma9DjZmsV95UsRrG4xjkpBEMzoqTA8e6z5DvWAWX4HjZ5SoD7PYaHoqXQNmpqbQHwsh8UBryQa6R3cN45p1gzGy17n0Q1bXE5rPqfhBS1JbslAho8hn0Nm34=
Content-Disposition: inline
In-Reply-To: <20180130120852.GA21609@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue, Jan 30, 2018 at 01:08:52PM +0100, Michal Hocko wrote:
> On Tue 30-01-18 11:58:51, Roman Gushchin wrote:
> > On Tue, Jan 30, 2018 at 09:54:45AM +0100, Michal Hocko wrote:
> > > On Mon 29-01-18 11:11:39, Tejun Heo wrote:
> > 
> > Hello, Michal!
> > 
> > > diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> > > index 2eaed1e2243d..67bdf19f8e5b 100644
> > > --- a/Documentation/cgroup-v2.txt
> > > +++ b/Documentation/cgroup-v2.txt
> > > @@ -1291,8 +1291,14 @@ This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
> > >  the memory controller considers only cgroups belonging to the sub-tree
> > >  of the OOM'ing cgroup.
> > >  
> > > -The root cgroup is treated as a leaf memory cgroup, so it's compared
> > > -with other leaf memory cgroups and cgroups with oom_group option set.
> >                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > IMO, this statement is important. Isn't it?
> > 
> > > +Leaf cgroups are compared based on their cumulative memory usage. The
> > > +root cgroup is treated as a leaf memory cgroup as well, so it's
> > > +compared with other leaf memory cgroups. Due to internal implementation
> > > +restrictions the size of the root cgroup is a cumulative sum of
> > > +oom_badness of all its tasks (in other words oom_score_adj of each task
> > > +is obeyed). Relying on oom_score_adj (appart from OOM_SCORE_ADJ_MIN)
> > > +can lead to overestimating of the root cgroup consumption and it is
> > 
> > Hm, and underestimating too. Also OOM_SCORE_ADJ_MIN isn't any different
> > in this case. Say, all tasks except a small one have OOM_SCORE_ADJ set to
> > -999, this means the root croup has extremely low chances to be elected.
> > 
> > > +therefore discouraged. This might change in the future, though.
> > 
> > Other than that looks very good to me.
> 
> This?
> 
> diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> index 2eaed1e2243d..34ad80ee90f2 100644
> --- a/Documentation/cgroup-v2.txt
> +++ b/Documentation/cgroup-v2.txt
> @@ -1291,8 +1291,15 @@ This affects both system- and cgroup-wide OOMs. For a cgroup-wide OOM
>  the memory controller considers only cgroups belonging to the sub-tree
>  of the OOM'ing cgroup.
>  
> -The root cgroup is treated as a leaf memory cgroup, so it's compared
> -with other leaf memory cgroups and cgroups with oom_group option set.
> +Leaf cgroups and cgroups with oom_group option set are compared based
> +on their cumulative memory usage. The root cgroup is treated as a
> +leaf memory cgroup as well, so it's compared with other leaf memory
> +cgroups. Due to internal implementation restrictions the size of
> +the root cgroup is a cumulative sum of oom_badness of all its tasks
> +(in other words oom_score_adj of each task is obeyed). Relying on
> +oom_score_adj (appart from OOM_SCORE_ADJ_MIN) can lead to over or
> +underestimating of the root cgroup consumption and it is therefore
> +discouraged. This might change in the future, though.

Acked-by: Roman Gushchin <guro@fb.com>

Thank you!
