From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement unified hierarchy, v2
Date: Tue, 15 Apr 2014 18:08:09 -0400
Message-ID: <20140415220809.GD13099@mtj.dyndns.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
	<534C983B.7080701@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=ys7U8WzycnW+vUwbENsL+18IHu7PiMRKkSeowKdZJtM=;
	b=Tv1KZoV7AfZqDgPprDbH8ScNoS+UIa5ArdOJg2bNG8jy9oMHeYmolXgOMn3Bq0DyJ5
	EakHoSzBYyoR9DqCXDRVQN65kpDXF9Ag6Vy8zSoQIdESjuawlF7Dplr+64FSkRfdMgcr
	uEoazNZFuc4j/sd/0sL3gDtbvKKbDNoZQqwNjgHOJO2Ic34nsQIt1CBZRI7KzfoHIREE
	bS2/hEzsn9za2C6MEhMIbyx6mYis0/UW5YkHPzEccnCQpZmxCVAKvsXAP8NQNmJ1+Awd
	Sc7p840NadKzzH6Hacj3ByKwjqFpf2hgRYDJh8z9Nk514f7/KGTX99qCeZ2GZMzXnE4+
	EHOQ==
Content-Disposition: inline
In-Reply-To: <534C983B.7080701-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 15, 2014 at 10:23:55AM +0800, Li Zefan wrote:
> Right after bootup:
> 
> # mount -t cgroup -o __DEVEL__sane_behavior xxx /mnt
> # ls /mnt
> cgroup.controllers  cgroup.procs  cgroup.sane_behavior  cgroup.subtree_control
> # cat /mnt/cgroup.controllers
> cpuset cpu cpuacct memory devices freezer net_cls blkio perf_event hugetlb
> 
> I don't see any controller knobs...

This was because cgroup_apply_cftypes() was skipping the default
hierarchy while rebinding correctly populated it.  I was alwasy
testing by unmounting other hierarchies so never noticed it.  The 0.5
patch that I just posted should fix the issue.  git branches have been
updated accordingly.

Thanks

-- 
tejun
