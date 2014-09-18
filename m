From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: simplify proc_cpuset_show()
Date: Thu, 18 Sep 2014 13:27:47 -0400
Message-ID: <20140918172747.GD13573@mtj.dyndns.org>
References: <541A91C3.9000305@huawei.com>
 <541A91D8.8070407@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TLMuz4zRetl8FF04NJAYS6iTl6zJG2a6+SgN60mJ24I=;
        b=w5lpaJTUtDAveI+c9qZ0MzIYdtH6yhQRTCmoPYs7I2SmUslyxZj3NnNo8EiOs9zVEa
         MWFfyQMNzHObqO8oHzmALkHoD13fWyXiKGynqsJA9YeQXkGQ4hEWtzD3yiwun1q9xKnM
         YdXLcreMxAINkIZBPyFVElTXKlA2keBsQu8i8AsDoYMf4mPYBqGkt4ykbtW5ignWbMEd
         SsZHmO5dAfzpcHUQnGwAVss072uvusKUjiDw5bjvqhpyVh5SoL4qbC3q0hBIkdgbqNIJ
         YMwUfAoIcDnV4eJArm4+b5Fv6hNUI/DLolrt7nKienYxkvBzW3S1OP9eNwyFO1yRzuZe
         uJGw==
Content-Disposition: inline
In-Reply-To: <541A91D8.8070407-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 18, 2014 at 04:03:36PM +0800, Zefan Li wrote:
> Use the ONE macro instead of REG, and we can simplify proc_cpuset_show().
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-2 to cgroup/for-3.18.

Thanks.

-- 
tejun
