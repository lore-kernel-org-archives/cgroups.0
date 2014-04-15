From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Date: Tue, 15 Apr 2014 00:57:41 -0400
Message-ID: <20140415045741.GE1863@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
	<20140414154556.GA9552@redhat.com>
	<20140414175236.GB15249@htj.dyndns.org>
	<20140414181421.GC9552@redhat.com>
	<20140414192139.GB16835@htj.dyndns.org>
	<534CA050.8060709@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=qca6/ECxME72U4kv63g9MVdlDgmkqCisKGLiFj/y03E=;
	b=SAbd8stb4H7Jvgd2ZyzJAzvEtzvoRyr9j4oVhi/AyTGgUAbJ6Fh3sRGGKS2ses5Bux
	YQFp3pUkWe1sopZ956028tpkaQ+T8OQ/0dilMl6EVJ8KaDl3BrX1SSkDBte0TClJSHqn
	UlL0yM/QSd1KOPKnCcGE0M3DUg20NDQI6pMTJ5saUK2yUMd9M2NqlOjnQIRBtr9SH/hs
	KFBVfeMf7dU2KZgm+jtoeXqupeGz/YMdn+WPDcSPVHidt9ZMFGBMWgIIx+ZMiiWL5Xcl
	Wwrj5y5Uhfn2Qa5kA2z43SW45wrsxpPjLVZg5dSZduZFASZ0qgzKE6IiV9WVulDX5Gak
	0TQw==
Content-Disposition: inline
In-Reply-To: <534CA050.8060709-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Tue, Apr 15, 2014 at 10:58:24AM +0800, Li Zefan wrote:
> I know we should allow multiple hierarchies, but why we allow this even
> if sane_behavior is specified?

Oh, because we didn't have unified hierarchy before.  The whole
sane_behavior thing is gonna go away.  It'll be absorbed into unified
hierarchy and probably be handled as a separate filesystem type, so
the current situation is transitional.

Thanks.

-- 
tejun
