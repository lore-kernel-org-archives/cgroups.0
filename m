From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: implement task_cgroup_path_from_hierarchy()
Date: Tue, 14 May 2013 11:45:43 -0700
Message-ID: <20130514184543.GP6795@mtj.dyndns.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=VQBVKwFYhBPqG8p3CX91bkui/ty7/v5M4+cQhTJg9zY=;
	b=HVPmmKMmVUD1OM3hM+OAJOL/pAQoWuYzRQhvla7b0tgCG/d2NV4G1XDvoNOqG3ADK/
	yO7H4kAuF/yENZUjDuBm4J6i0vhARWB3d1OooFkQP+E6hRkIqf9Zis/HvkThhT4VrSGk
	qNw1G9u41624/HMHb2p4sNWLzWI6QwPBAWtHwloowVLWBqWRnC0HB7YX5dcu7xNIBQMT
	X0mhktNWHHTrMHuozRqtzjVwZnlAdo85QvJoIwxHmxvcExjjGiQ9wQVlPDvDGUAVGeQ1
	581L2dhVa2g1EALROyrcyW87ioZW2ANJvZ0/kTOBoYJ39mgiPt8rOLuGHp0ZbjGx3XPy
	vLCw==
Content-Disposition: inline
In-Reply-To: <1365964619-14762-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kay-tD+1rO4QERM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org

On Sun, Apr 14, 2013 at 11:36:55AM -0700, Tejun Heo wrote:
> kdbus folks want a sane way to determine the cgroup path that a given
> task belongs to on a given hierarchy, which is a reasonble thing to
> expect from cgroup core.

Applied to cgroup/for-3.11.

Thanks.

-- 
tejun
