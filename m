From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cpuset: decouple cpuset locking from
	cgroup core
Date: Thu, 6 Dec 2012 08:54:26 -0800
Message-ID: <20121206165426.GM19802@htj.dyndns.org>
References: <1354138460-19286-1-git-send-email-tj@kernel.org>
	<20121203152205.GB17093@dhcp22.suse.cz>
	<20121203165338.GF19802@htj.dyndns.org>
	<50C03A3F.7070605@huawei.com>
	<20121206130904.GC10931@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=j5ePKzQGe+wy0XUwb8YA3UWT3iqfUBXMMkvzJ5HwNwk=;
	b=zYpqXLZ3mtxwosbrLhtf/6bHoRaxDDU/MNV30ka8qATSNI8i3CTEnkzovluA7Rqnlt
	yjAY9v7mD24pXRlfzGudKT+D84OCBAm3tD/Q0bGk1W8BuRHf5en3GKqDJgua8jrTJFNL
	rs7+4tbrNQFgR/hZRpRWZ2yUDGM74p+wEeUFZNdzng6sliS5kv/hJqhNPeiuDclBgvf9
	MQzCA61mrKnhh0zttyLNisStLMCk09m2486XC4TQVaHiIaD3c/Jfp05Q4k6DByd4aywL
	fOzdvxWuyqur5rgAPU+8Bq/u98JJtWylOUhu11JkCrUmCOUJkQQP7WmygEVzg4EBZ+t4
	bb4Q==
Content-Disposition: inline
In-Reply-To: <20121206130904.GC10931-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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
Cc: paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hey, guys.

On Thu, Dec 06, 2012 at 02:09:04PM +0100, Michal Hocko wrote:
> > We shoudn't haste to target this for 3.8, given that we're in late -rc and
> > Michal felt some patches scary and they hasn't got enough review.
> 
> Well, even the original code is scary enough so if the decision should
> be made just based on my feeling then it would be too sensitive
> probably. Anyway I do agree that the series should see review from
> others who are more familiar with the code before considering for
> merging.

It's already too late for 3.8.  All cpuset changes are for 3.9.

Thanks.

-- 
tejun
