From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 cgroup/for-3.7] cgroup: mark subsystems with broken
	hierarchy support and whine if cgroups are nested for them
Date: Fri, 14 Sep 2012 12:06:08 -0700
Message-ID: <20120914190608.GM17747@google.com>
References: <20120913183402.GG7677@google.com>
	<20120913192058.GH7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=ncJO6fL3/B4wFvqBAzKYQo5UWoKjMTAQCqJ3Bf9AV1s=;
	b=rmqTPE7vqwxz2sMizW3BE2IRzSM73UJ4CO78Ryy3q9PJMdQY7qqleSQit1rPJAU91j
	oqkX2YpOrrQrgfyRGUGoIvs/lmv9wsHUrp3OMFNNz86yy3uJPn+g1MctdCN+FVWgQoQx
	XqOaavdUSl1ZJz4VV6dgDrTvajspL2OodWwe3nb9sCVxLirPB7spkmhnIAsUUGVmjwps
	aNwv/AAi2mRDdf4U4XVR7ffxOVX8RCWbli7qxvAyiNGX3seHWPk5r2s53LK0ZQ6uVSTo
	PP/TjVMa/cMoqJmZdts+crAgzVUYk+/dDf6IOhhMPuwbojNwznDMDluzu/EpYYf3o4Jj
	TT5g==
Content-Disposition: inline
In-Reply-To: <20120913192058.GH7677-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
To: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Sep 13, 2012 at 12:20:58PM -0700, Tejun Heo wrote:
> Currently, cgroup hierarchy support is a mess.  cpu related subsystems
> behave correctly - configuration, accounting and control on a parent
> properly cover its children.  blkio and freezer completely ignore
> hierarchy and treat all cgroups as if they're directly under the root
> cgroup.  Others show yet different behaviors.

Applied to cgroup/for-3.7-hierarchy w/ acks added.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.7-hierarchy

The branch is based on top of the current mainline (fbcbe2b3c 3.6-rc5)
and only contains hierarchy related changes.  The branch will be kept
stable unless I do something completely stupid, so please feel free to
pull into other trees as necessary.

Thanks.

-- 
tejun
