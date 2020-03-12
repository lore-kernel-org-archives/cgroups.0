From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 0/4] Support user xattrs in cgroupfs
Date: Thu, 12 Mar 2020 23:05:12 +0100
Message-ID: <20200312220512.GA614185@kroah.com>
References: <20200312200317.31736-1-dxu@dxuuu.xyz>
 <20200312211735.GA1967398@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584050716;
        bh=BTpIEKtjB3xS8Vr88vILZ1/PyE+yHgP6lcXkkl1uiTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hlCHVt9vSpN0nO4WKoQ4CaiSFxd7Cb27vMQY8jGeM8rNWy8Bb9999bcCaochj/gD4
         FzTgBR79rC4+rMZIU1QDDKzSTa6AJ5118ZkPjhrKz/UJ+0IfLRlT3xH3g9sEh8UM9x
         mvRtV6WEU7YoOoURFCPmg+iQbVkT94X3HzJ5V5zA=
Content-Disposition: inline
In-Reply-To: <20200312211735.GA1967398-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Mar 12, 2020 at 05:17:35PM -0400, Tejun Heo wrote:
> Hello,
> 
> Daniel, the patchset looks good to me. Thanks a lot for working on
> this.
> 
> Greg, provided that there aren't further objections, how do you wanna
> route the patches? I'd be happy to take them through cgroup tree but
> any tree is fine by me.

Sure, feel free to take them through your tree:

Reviewed-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
