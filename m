From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.15] cgroup: cleanups after kernfs
 conversion
Date: Wed, 12 Feb 2014 09:30:24 -0500
Message-ID: <20140212143024.GK24490@htj.dyndns.org>
References: <1391877509-10855-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qOkeFXYp6lBe+tittrWuF8D5uvg0QnbSeqnv1nXaRIE=;
        b=THfaj8lH/Sn7+uH3lUGoktSV9H7jnwcryYHK/SIYV3AXbL0bXkYyIi1zKwvQ2TjHO6
         qaWYr13heWmRTQx/K9oOzrMsiqqbE+nRIhbYLVzFskuASng/1M08n2knaXdh/hgQpuJq
         81E7VpUp4GWfAVb17KvYP3jswdPp/nSzxuv5SMGLjKsDyizp6PH5UWwMsQP2BGCQ0s84
         oXuIpR0uM0ENmz44WjWWWX0AQIqf55SoWmcSQwGPoBuLX8wVttKldIEumiMw3OpwaQeC
         tAQKYUn6V6E6uWtUR1M0QnzVaNz42E7xg4Cn4WuTRGpM852dptWvzQ3/v5aMzMatvYrp
         T7mg==
Content-Disposition: inline
In-Reply-To: <1391877509-10855-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Feb 08, 2014 at 11:38:21AM -0500, Tejun Heo wrote:
> Hello,
> 
> This is v2 of cleanups-after-kernfs-conversion patchset.  Nothing
> really changed since the last take[L]. It just got rebased on top of
> the updated patches.
> 
> This patchset does a number of cleanups which are possible now that
> cgroup is converted to kernfs.  This patchset contains the following
> eight patches.

Applied to cgroup/for-3.15.

Thanks.

-- 
tejun
