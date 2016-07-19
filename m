From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: remove duplicated include from cgroup.c
Date: Tue, 19 Jul 2016 14:29:10 -0400
Message-ID: <20160719182910.GJ3078@mtj.duckdns.org>
References: <1468929759-9088-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oFmh9JA9pdRX+8a+TRzDCaBokn6iZCokd2kSgGjppGw=;
        b=wkRVis652FR02Rtc0w+ptJT5PvpwdY5KsBKuKHjTYsCNXTDKHTsK5+3TxKYGUZoBnF
         qd4DzcP49SYxn/yd/igqq2NpmmoLpDcsMP63SqXzv2q73ocsI9XnWhAdLO6wgaBmhv+y
         FF0CC99LIX0n7NKh9tsNjBRcS7Xstdj5xPXHWYyd9nT6bsuD2uImF/zMj9ZFqOuFLEKl
         AzZ8eQHUl/QX7JCvQ7anrN9GvDfF0o7cA/V9NIv1QZDP7KCDIohLpTd/ZFd/ERbQ8wJU
         3CtSmMMyANUNZMrZMRmAMPMb1gOMJhVCzG1i3ksY1Tu361eLNu95oPI0kO03K4SW7e+H
         Z8Uw==
Content-Disposition: inline
In-Reply-To: <1468929759-9088-1-git-send-email-weiyj_lk-9Onoh4P/yGk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yongjun <weiyj_lk-9Onoh4P/yGk@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 19, 2016 at 12:02:39PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Applied to cgroup/for-4.8.  Thanks.

-- 
tejun
