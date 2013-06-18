From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-3.11] cgroup: disallow rename(2) if
	sane_behavior
Date: Tue, 18 Jun 2013 08:16:54 -0700
Message-ID: <20130618151654.GF2767@htj.dyndns.org>
References: <20130614034717.GA31533@htj.dyndns.org>
	<20130614181822.GC6593@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=zLP8U0HH2/h5b0uwpbd5ZrCft6c6aw2eW4J+K+THMeA=;
	b=GhHS1mhK8rG013A66gl3RATmti3j+klYt/YSU0fgGRLszMpnUnPA5WVjohpjMHtbNx
	s6BV78hkHfOphzSK1bsGPKkhDuayHt5m2gZtslF8yCamfxZPWzjgki48jd2yNakbulAC
	NUDuJH//r+QY7n/8TjjqALgJ2DpxYr8eNqN0rR3sTwFTz+A65HIkbEOXmevUIltn00zj
	rpSbAHe86yicOz/B40p6WtVZiWlPS8glzevdf4KkBdlACh3XBEkIzlboSgYOJjRBQPU2
	X3pjb94IyRgP311httm5YQf2zXSVaBqJMs1XlWSOA4XvKEZCr252s7dkX/53OPMLAsuE
	WBGg==
Content-Disposition: inline
In-Reply-To: <20130614181822.GC6593-9pTldWuhBndy/B6EtB590w@public.gmane.org>
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
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>

On Fri, Jun 14, 2013 at 11:18:22AM -0700, Tejun Heo wrote:
> cgroup's rename(2) isn't a proper migration implementation - it can't
> move the cgroup to a different parent in the hierarchy.  All it can do
> is swapping the name string for that cgroup.  This isn't useful and
> can mislead users to think that cgroup supports proper cgroup-level
> migration.  Disallow rename(2) if sane_behavior.
> 
> v2: Fail with -EPERM instead of -EINVAL so that it matches the vfs
>     return value when ->rename is not implemented as suggested by Li.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.11.

Thanks.

-- 
tejun
