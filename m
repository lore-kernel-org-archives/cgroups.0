From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.14-fixes] cgroup: four misc fixes
Date: Sat, 8 Feb 2014 10:25:51 -0500
Message-ID: <20140208152551.GC3263@htj.dyndns.org>
References: <1390923125-4369-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=l2bANOcE4eaaLUxicA6HLtGsuxJPLL7tTjpmj4eaxWQ=;
	b=HJSM/PKkfXbaAPQnKxq0NLbHX1xrAlUacQ5txQrGdPsXwy8TTADRMpl+H23x/Ju4mU
	sYdKrG09QNivl5FTzTyMp8F2zsh22cyUmXj0ELfd4tUkKcgEvvpB0ZwkLGmjOuYpycgK
	JokvsExuntOupTDrnRw7zMMyqm+PnoR3Q8k15wjYvW2szX9i5uuBZqOgSAVmDZLwj+Eq
	zRcwFF8S5WLGb/pq+lBSQz8tJBWMB4b4gj31e7ZsaYhMdsZBFA7vOD8EAlZzglg11HM3
	z5DcJsxWa+Bf4Q0G2NDOxAhC1EZjQhtRYX/bHhasVhIWGhBHZf2W13rjjjHhj0PVs9Sy
	uqoQ==
Content-Disposition: inline
In-Reply-To: <1390923125-4369-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 28, 2014 at 10:32:01AM -0500, Tejun Heo wrote:
> Hello,
> 
> This patchset contains the following four fixes found during
> conversion to kernfs.  0001-0003 are marked with -stable.
> 
>  0001-cgroup-fix-error-return-value-in-cgroup_mount.patch
>  0002-cgroup-fix-error-return-from-cgroup_create.patch
>  0003-cgroup-fix-locking-in-cgroup_cfts_commit.patch
>  0004-cgroup-move-the-one-off-opts-sanity-check-in-cgroup_.patch

Applied 0001-0003 to cgroup/for-3.14-fixes.  Thanks!

-- 
tejun
