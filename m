From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
	default hierarchy
Date: Tue, 15 Apr 2014 12:52:21 -0400
Message-ID: <20140415165221.GD30990@htj.dyndns.org>
References: <1397511846-2904-1-git-send-email-tj@kernel.org>
	<1397511846-2904-4-git-send-email-tj@kernel.org>
	<534C83F1.9020106@huawei.com>
	<20140415145450.GL1863@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=rqy3c4uP8BFKN9GJ9fXPaBzIlPJQ7wO4WPbELtE153g=;
	b=GHQ3r2Cn/wZAh2ZSCNiNyK/b+qb14Hq8wpkY/efg2lLsXc+c4StDkixZdCnfIc0mN2
	93mHkxbZlRUs8f86TaXuSEPWehHt3XDg0KIlc1Sims/N16/qV4tYpumzCOeuaZxVFcGk
	R2iZbvGsG0mk2jmMUZTJ2eCYMEP9kG/R6TBztkMN+bDilTcgzaWN+1QNyoPcVw6n0NGG
	LFoVqOQMC2bV/x2tkOmrxWDNjcAkQGETIB0UNLikVfSOAcJfzHWze3bqoglQsC51Pjq4
	K25olAbx9OsAg87W3nG1eR8ddLCoitE7gCV3Eizno9i7ILQ93gnm6LxpVbHSND7s6zm4
	MPRg==
Content-Disposition: inline
In-Reply-To: <20140415145450.GL1863-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
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
Cc: rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, kay-tD+1rO4QERM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org

On Tue, Apr 15, 2014 at 10:54:50AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 15, 2014 at 08:57:21AM +0800, Li Zefan wrote:
> > Is cgroup.tree_populated a better name?
> > 
> > cgroup.subtree_control controls child cgroups only, but .subtree_populated
> > shows 1 if there're tasks in the cgroup or its children, so the two
> > are a bit inconsistent to me.
> 
> Yes, good catch.  subtree_control affects subtree proper.
> subtree_populated covers self too.  The difference is subtle and the
> trade off between shared pattern in names and clarifying the subtlety
> didn't seem clear-cut to me.  Hmmm....

How about cgroup.populated?

-- 
tejun
