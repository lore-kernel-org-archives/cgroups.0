From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] cgroup: fix locking in cgroupstats_build()
Date: Fri, 14 Feb 2014 10:57:51 -0500
Message-ID: <20140214155751.GB31544@htj.dyndns.org>
References: <52FDD9C4.1070001@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Vz22PMC4Xy81rYm2j4FkzkXfkJzTvLWyMmAXlckceG0=;
        b=KYJVJAaYJzBgVBUfz4B60YL5+2p2Fyk7XH9JPdE8oDHxvQvaw/O9g2KyUOkcXZAMiv
         isWRe5hJZtA1aDi58fOO0ABsUiElkp07KutQqygIB6dv9q9KQvbchZMoc1wn0gzHKY+r
         XVqTOu+7YLTxwAObJclak+OQxkXN2sgiQAwy42/hCC/RhbTV45nw5JqRBDz4mXoswsOs
         sv19oIklUhwybSeNUD9kYNsTQIADBFwxYMCDCx8pefSI/h7E748S1zZ3EObpOXDSqYRL
         tFZq5q8fD7X5W3IWOZ/+4CcFogONP5vtaoEXC4/yJlQ2MNTlwL3o4YNgbnvLTlMRaujm
         UgMw==
Content-Disposition: inline
In-Reply-To: <52FDD9C4.1070001-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 14, 2014 at 04:54:28PM +0800, Li Zefan wrote:
> css_set_lock has been converted to css_set_rwsem, and rwsem can't
> nested inside rcu_read_lock.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-3 to cgroup/for-3.15.

Thanks!

-- 
tejun
