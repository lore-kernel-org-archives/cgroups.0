From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND] cgroup: remove subsystem files when remounting
	cgroup
Date: Mon, 3 Dec 2012 08:34:23 -0800
Message-ID: <20121203163423.GC19802@htj.dyndns.org>
References: <1354292489-18434-2-git-send-email-gaofeng@cn.fujitsu.com>
	<1354498098-17312-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=HqENmASVvdc3ZJyDwHLV3W0F0IlCUkUYKsueDooaoOo=;
	b=cOzaGkFkl6Fw0tDit8oVp3I+1g/L22MeEYY52tD1ju/eqh9cKkZW6WEpyRK+ODZGwb
	h7DQHJwRTsYeHFQSt0W9ZVLpENAw7omImqd+mfj1Aq/FNtEoe2GxV/xYiIKVVqn6lCbV
	MqNMlyJGrJCrGk4ttoV+TvYV90v/ZC8u5HQ3146ZoMddNGZWUWaUumbSQrus4kBvtG2V
	HwQayZwOm983tWm+xRvLGHk4sOI80dAh2xvv75AynQhEIVZh6anUyCVignRaTbOlSIEl
	MSJxOTKPTnYz+0vNjdPRCJHfpu+s2rUNk0MT9nwRwYtakHgRwFnJUb11w3pjQRd9E5fj
	U87g==
Content-Disposition: inline
In-Reply-To: <1354498098-17312-1-git-send-email-gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
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
To: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Dec 03, 2012 at 09:28:18AM +0800, Gao feng wrote:
> cgroup_clear_directroy is called by cgroup_d_remove_dir
> and cgroup_remount.
> 
> when we call cgroup_remount to remount the cgroup,the subsystem
> may be unlinked from cgroupfs_root->subsys_list in rebind_subsystem,this
> subsystem's files will not be removed in cgroup_clear_directroy.
> And the system will panic when we try to access these files.
> 
> this patch removes subsystems's files before rebind_subsystems,
> if rebind_subsystems failed, repopulate these removed files.
> 
> With help from Tejun.
> 
> Signed-off-by: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Applied to cgroup/for-3.8 with spaces added after commas.

Thanks!

-- 
tejun
