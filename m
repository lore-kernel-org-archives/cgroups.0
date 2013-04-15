From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/4] cgroup: introduce sane_behavior mount option
Date: Sun, 14 Apr 2013 19:54:04 -0700
Message-ID: <20130415025404.GF3050@htj.dyndns.org>
References: <1365808259-31073-1-git-send-email-tj@kernel.org>
	<1365808259-31073-4-git-send-email-tj@kernel.org>
	<516B6AAB.8010507@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=YsEy79a/jX26YUNkaMsTBscNWOg/77jEAvc7PfRi4lA=;
	b=AMmIovMlfdiNW2SQ9NVy/XSalmE50wcKk+aLBcgVOgE+tkOqnDlt4atwphXr3dkdE4
	CQWzgZQUF2qb1dpX0LwsnjFaUAJeyytNGlM1N/b/bhcNwQjGNTvaEDmoIDP6YkXFqYj+
	NuPO5lxoTG1C9KJ5MgQ2944tFobwNEvtRvASQG7I4YonTCXVg9ydb3DPlpZroIIe6mBK
	/pMwSQ7Rlnwly8BfaWlNFcgu8SX5197CDp0OkfD8slJm69hUpLTK2H9NvTI4buyI4As1
	QBLEQl6WpuRZo58LD5PfK4RzByioqtSrnB++U0UDS+mYJ01FUHDEslWHCJZprmZA8PRP
	eywg==
Content-Disposition: inline
In-Reply-To: <516B6AAB.8010507-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 15, 2013 at 10:49:15AM +0800, Li Zefan wrote:
> >  	{
> > +		.name = "cgroup.sane_behavior",
> > +		.flags = CFTYPE_ONLY_ON_ROOT,
> > +		.read_seq_string = cgroup_sane_behavior_show,
> > +		.mode = S_IRUGO,
> > +	},
> 
> We don't have to set .mode explicitly.

Right, dropping.

Thanks.

-- 
tejun
