From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
	cgroup core
Date: Thu, 3 Jan 2013 17:20:39 -0500
Message-ID: <20130103222039.GD2753@mtj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
	<50DAD696.8050400@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=RQ7gHF3N8Y4zm2HdiEN7n2WzTgs6OaXs+x5QEDhUccA=;
	b=IhtNG7kifRU0QLXpDuO7rHjPFm+IW0n5jFWVOqzdsLpmuI4aTftKKrhCp2w7f3/8rv
	9ymCwVj91roabzCilsdWdwOcbevsuT4vMhyiAkISrAmBTDbGYSfIPHNGHiX8mfM1g4WQ
	/C593izSvqdRk9qXxghGoqbZJhF246xJHQwCIsBi+a52Z0R3OtnFTwWhxhlBo4RIJ3Tk
	Pq2r+xjGNjGajLLJDKtD+ey1SXGA1M+ywzol/vFzqj+8PMDKvRm9bWTvj4li6wkMJC2B
	pVcBmMJF3fHKti/ZQxqgTf1cQzyzZ9GUX8tVysdgnvIT+FnRYA42COjxW5dlFWcRQcLX
	j9jw==
Content-Disposition: inline
In-Reply-To: <50DAD696.8050400-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hey, Li.

On Wed, Dec 26, 2012 at 06:51:02PM +0800, Li Zefan wrote:
> I created a cpuset which has cpuset.cpus=1, and I forked a few cpu-hog tasks
> and moved them to this cpuset, and the final operations was offlining cpu1.
> It stucked.

This was caused by not rebuilding sched domains synchronously from cpu
offline path.  I looks like scheduler got confused and put tasks on
the dead cpu.  Should be okay in the updated patchset.  Can you please
test / review that one?

Thanks.

-- 
tejun
