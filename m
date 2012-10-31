From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: simplify cgroup removal path
Date: Wed, 31 Oct 2012 09:35:18 -0700
Message-ID: <20121031163518.GB2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<20121031163134.GH22809@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=jWK5B9QpAKE8FaOWM/ZS+xgXDDe38OUDH7SLA360tRw=;
	b=rtNkFPfu/+allG5rDXR04KlQEfPFfjqY/QsNOfdgbITFmaqZAyX/SvlYFtpAXiEVbN
	8lF7rOsMImlmmVNv/yZAOtWZDKkxr1rfy/HgwMgkeVeGtsuqgEyIYXnl8J6VTobSuQWm
	cShWwUHPaMsLx0gI57Rjw0p8NyRdqCOq+iVtN/i69Zr5iYUCeqDXT8tVh2Ar/7caxDRP
	0pAwnAGJ6fzRSTVP+RD6lZ+lr4EgsUp98UX97YWPaNFXxKHqD9BxQQnfkoo1/aP1mkgE
	VASpG5lLV8KPj9Rsk4BOvabzdXwbga47VYzzCbYuNIkJGAc5p63h92FSZfKEeP9CjGEh
	JxWA==
Content-Disposition: inline
In-Reply-To: <20121031163134.GH22809-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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

On Wed, Oct 31, 2012 at 05:31:34PM +0100, Michal Hocko wrote:
> Thanks for this cleanup. The code looks much better now and:
> $ git diff --stat mmotm...tj-cgroups/review-cgroup-rmdir-updates
>  block/blk-cgroup.c     |    3 +-
>  include/linux/cgroup.h |   41 +-------
>  kernel/cgroup.c        |  256 ++++++++++++------------------------------------
>  mm/hugetlb_cgroup.c    |   11 +--
>  mm/memcontrol.c        |   51 ++--------
>  5 files changed, 75 insertions(+), 287 deletions(-)
> 
> speaks for itself.

Oh, yeah, I've been wanting to do this for so long.  :)

Thanks.

-- 
tejun
