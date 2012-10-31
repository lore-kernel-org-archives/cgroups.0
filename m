From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/8] cgroup: deactivate CSS's and mark cgroup dead before
	invoking ->pre_destroy()
Date: Wed, 31 Oct 2012 14:27:25 -0700
Message-ID: <20121031212725.GA2945@htj.dyndns.org>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
	<1351712650-23709-5-git-send-email-tj@kernel.org>
	<20121031212359.GC5286@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=Dg7P0Vf3Cw94nj+j0Uyq4Vt4aSfK1R/JcL3rvhxg8U0=;
	b=zYpZQk/N515qb+BIviCcoHKYK6sy+P7Wpg/7uI6HxZb3S9qps7Zv4ovaWMII7wr0gr
	ubocsd9zQwTg67fh6U/DGgCsBoy/YT7beX8X7vU0WGW15u8wjeDRgnzTsWz4plpNXMCE
	2uWgiSiYnt7gbn6vil8ZIDFTxjIR2uSHrDSNrLgFrzkv86D7pHyOPdcH29bGEtXYUfmf
	ZE6uLrGL5StQRDMBzdyU+cz5aucYudqOGjQ8LYn5SInUJDhZ+Yk/ZEuc42V+xojG91vG
	Af4HCb7xUfJq7mkgsTQ63KfhAYrvPOouAReSe48np/4o5Qsu9rPOUsxEXGgO/eKkqkdB
	kTrw==
Content-Disposition: inline
In-Reply-To: <20121031212359.GC5286-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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

On Wed, Oct 31, 2012 at 10:23:59PM +0100, Michal Hocko wrote:
> > +	for_each_subsys(cgrp->root, ss)
> > +		if (ss->pre_destroy)
> > +			WARN_ON_ONCE(ss->pre_destroy(cgrp));
> 
> Do you think that BUG_ON would be too harsh?

Yeah, I do think so.  In general, I think the consensus now is to
prefer WARN_ON[_ONCE]() over BUG_ON() whenever possible.  It's not
like we can get more information from BUG_ON()s (more likely to get
less reporting actually by taking down the machine).  Limping machines
are better than dead ones and there just isn't much to gain here by
killing it.

Thanks.

-- 
tejun
