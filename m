From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/4] Support user xattrs in cgroupfs
Date: Thu, 12 Mar 2020 17:19:24 -0400
Message-ID: <20200312211924.GB1967398@mtj.thefacebook.com>
References: <20200312200317.31736-1-dxu@dxuuu.xyz>
 <20200312211735.GA1967398@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JTXt1OEkKePago7QylMBAyiYQ7S4tVDId/6muJlv8kg=;
        b=WDSCCAorJeZ6KuiLgpb2NOSuo5qVP6GWOxv/Q3FR28T2zL7W+mcqNlfnGGZhnDWjJc
         FbZic2wgZZBaJR4YRNQSIU1F7PdbMnH7lg5OIEUOQuGEYXKc3nFeMbkcZyc/3GBYpteA
         8I1D7Ld0Ly3b1oXygzubVBMi69vuzBm+ilXd+LUMJx279TKgeV/XMGmyZGfatd8/qv+c
         dVGuv+qOx23jt+V0u+FdAv69c0ytBhKqK8LKxHlGISNGM/YYv8fdSgL7VRpOvFiGsK87
         4VUhQ8APCO0bRvlsbyb6gdOpwfnTHjJ2nuAaWaRjR4Olio4yjE4sifW/bgIOjL0SCgwv
         IXkg==
Content-Disposition: inline
In-Reply-To: <20200312211735.GA1967398-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Mar 12, 2020 at 05:17:35PM -0400, Tejun Heo wrote:
> Greg, provided that there aren't further objections, how do you wanna
> route the patches? I'd be happy to take them through cgroup tree but
> any tree is fine by me.

Ooh, in case they get routed thorugh another tree, for the whole
series:

  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
