From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
Date: Wed, 31 Oct 2012 12:33:29 -0700
Message-ID: <20121031193329.GQ2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<1351657365-25055-3-git-send-email-tj@kernel.org>
	<20121031153926.GC22809@dhcp22.suse.cz>
	<20121031165739.GE2945@htj.dyndns.org>
	<20121031191602.GB1271@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=72yQ4Te/jvdjcXtFxvr9Kbld9EtizVwNBypbmtKbxkc=;
	b=J0H0leW93qCEDqr7S6TbXnRy6/ZpXcLQ7A6vHHzhV8IS6tMxcHI+Nzxr0ydseksZNH
	GrsG6DDZmCl4Nhex5tX3NtfiABzIpnHIMZ+U0j7vSCexqzfbKMWYOUBqjCQOTnEVFmhN
	gUIL6i2+FUuwtAXT9NqEVX3G423vi+fIXl1PXLerXnovdkfsKzNLfrU2hCQNf6nTMuG5
	BuokGmsQE6XxjAcMijNyeIOUfRLSNZnluJiOv610pP53Fx82wcb4olu1l9nRRNajZ4AU
	twqpqbUUtU7mLQxLKtTO0VgFM6oFs6qhrELKWDmtba/aOKc90SwvQS+X7pF6mfJBGfyi
	IOYw==
Content-Disposition: inline
In-Reply-To: <20121031191602.GB1271-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hey, Michal.

On Wed, Oct 31, 2012 at 08:16:02PM +0100, Michal Hocko wrote:
> Sure, it cannot detect races but this wasn't the intention of the check.
> The more important part is that memcg can outlive css and we want to
> catch bugs when we try to charge to an already dead memcg.

cgroup will provide mechanisms to perform such checks properly
synchronized, so let's not leak internals like CSS rercnt going
negative outside cgroup.c.

Thanks.

-- 
tejun
