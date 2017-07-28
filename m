From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: add cgroup.stat interface with basic hierarchy
 stats
Date: Fri, 28 Jul 2017 11:09:27 -0400
Message-ID: <20170728150927.GN742618@devbig577.frc2.facebook.com>
References: <20170727161420.2552-1-guro@fb.com>
 <20170727162243.GF742618@devbig577.frc2.facebook.com>
 <20170728130155.GA13728@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rTdygEsx1ODBoSsJt4vUsfEAgv1OqQ0Ohjfgvb4AbZE=;
        b=h3LbvJczWIlylvgcM9q7AoioEF17IvrpohmaKPj6NJ1aK3QcEQs2IEjvCUfuHJh4uG
         HYXYzr8b5bN7R3nYmfNtXi/tg+wFw716TdfvZctx85CD0kesSnRvS0NJ6PLmYbXNlQhJ
         ImDubM3Wayp6/IqA/qJ8UR5Gh7KfSL+rOMKuHKoE1zwsQCuWmsdeYvTWE+I5bac7Temt
         6hD6YUWizl6lZWDyC3QZvKxQiGHSA0vZesAi41DnKwNAmn6az3MT0VV7zbYj4XuidCtt
         xwh5peWFDdsKf5fbCZGuPdS8HakFpNtrk2T/0MtbiZQ9Q2k8IPACYuxLuNWT5Ne/xkKn
         yl0w==
Content-Disposition: inline
In-Reply-To: <20170728130155.GA13728@castle.dhcp.TheFacebook.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: cgroups@vger.kernel.org, Zefan Li <lizefan@huawei.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 28, 2017 at 02:01:55PM +0100, Roman Gushchin wrote:
> > > +	  nr_dying_descendants
> > > +		Total number of dying descendant cgroups.
> > 
> > Can you please go into more detail on what's going on with dying
> > descendants here?
>
> Sure.
> Don't we plan do describe cgroup/css lifecycle in details
> in a separate section?

We should but it'd still be nice to have a short description here too.

Thanks.

-- 
tejun
