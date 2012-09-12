From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
	broken hierarchy support and whine if cgroups are nested for them
Date: Wed, 12 Sep 2012 09:34:33 -0700
Message-ID: <20120912163433.GL7677@google.com>
References: <20120910223125.GC7677@google.com>
	<20120910223355.GD7677@google.com> <504F30DB.60808@huawei.com>
	<20120911170837.GM7677@google.com>
	<20120911174319.GO7677@google.com> <505057D8.4010908@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=s+2aaJjM6emxlc51pNloi5gPDucnitwPAQDLrBRl3Uo=;
	b=Wp9re3yR8x+NCrNX3BAZwJY7Iq5YtXVvIiOrYc48ZKsdtuHCQMJ0JWgkkRr+5kEORQ
	hM70jm0m8T+Iw1EsAjxxugH0rLjvTdDSFKW7RSJRfZn/frRz3QTDojbUe55E1w1UZKOb
	UPY1UuU8rYl2wTGtABz3Ocp+4D9xmaJ5EXHAF7GVh0ROI2octSSAK3ILjLW2mkzl2v4w
	/RAv2+Di9A4tvr14XsQgjzab82hAGCxSL5BSslTsI4oxhclZH2dPqmUm2j6LA8eZVbcz
	Ii23HfdUlCPgsPjTEQH4QUl1Hix+XM8b7pS9a0MRZy+kgjI0SZho1d2QBetCQvPv2Jsm
	NYXQ==
Content-Disposition: inline
In-Reply-To: <505057D8.4010908-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Wed, Sep 12, 2012 at 01:37:28PM +0400, Glauber Costa wrote:
> "If a cpuset is cpu or mem exclusive, no other cpuset, other than
> a direct ancestor or descendant, may share any of the same CPUs or
> Memory Nodes."
> 
> So I think it tricked me as well. I was under the impression that
> "exclusive" would also disallow the kids.

You two are confusing me even more.  AFAICS, the hierarchical
properties don't seem to change whether exclusive is set or not.  It
still ensures children can't have something parent doesn't allow and
exclusive applies to whether to share something with siblings, so I
don't think anything is broken hierarchy-wise.  Am I missing
something?  If so, please be explicit and elaborate where and how it's
broken.

Thanks.

-- 
tejun
