From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup: clean up obsolete comment for
	parse_cgroupfs_options()
Date: Thu, 17 Apr 2014 11:38:00 -0400
Message-ID: <20140417153800.GO15326@htj.dyndns.org>
References: <1397748555-6647-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=i2udQT+II5aTwMysG2Gd45ATe9N1QnEHgpUXS2TLDVA=;
	b=hCm5qTcRPsL05rRiIxI/Hm2q+soep/GMShVHJWFqvxyp8LCdSr0/oepOVzO4M+pgLb
	U4LDNZi4mHATUVgTukOKGPq2+0NqiYQ9qGnRJA5gbvuFjMdJ6B+x+8FVsZTTgk78Kop7
	UXilhOz+QkV/ZiwFJm8xXhSe0dkpBQZzFPjD8JmUHF5vLUTRRLy0pIuhtp91+JBdPrtZ
	2P7NnPJ77foM6lr5V64IS5lYuJJMrMdfdUfX8SIPmZAo0b0PfiKP7dtChNl9LvHT44bd
	ectbasaNk5m3ytfExZRmZKeg8X+CnbllASp7zZRl2NMkpjgbvZejqx7EpYslZYXzMFlt
	xuZw==
Content-Disposition: inline
In-Reply-To: <1397748555-6647-1-git-send-email-nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
To: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 17, 2014 at 11:29:15PM +0800, Jianyu Zhan wrote:
> Commit 1d5be6b287c8efc87(cgroup: move module ref handling into
> rebind_subsystems()) makes parse_cgroupfs_options() no longer
> takes refcounts on subsystems.
> 
> And unified hierachy makes parse_cgroupfs_options not need to
> call with cgroup_mutex held to protect the cgroup_subsys[].
> 
> So this patch cleanups these comment and BUG_ON().
> 
> Signed-off-by: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Rolled 1-3 to the pending patchset.  Will be applied after the unified
patchset.  I dropped the comment above parse_cgroupfs_options()
altogether as it didn't contain anything actually useful.  Also, next
time, please put the patches in a series into a thread so that they're
easier to track.

Thanks.

-- 
tejun
