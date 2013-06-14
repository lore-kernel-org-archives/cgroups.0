From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: rename cont to cgrp
Date: Thu, 13 Jun 2013 20:48:58 -0700
Message-ID: <20130614034858.GB31533@htj.dyndns.org>
References: <51BA8B83.8090607@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=H3Z9DBvZ/mXX13XH3qE4jC0zzSLjOKaWs41bN3o/cDM=;
        b=TbevmBCMlUlbVALGhPFsxOxOPD7N51Ox8FjgQACjmo7XhP3Nj3Df2ao3B8BtGIGXcU
         vrBHyfZAkwX9q0/P7CELGdHTXtLGqLSXYKEnCeVmg7iPbmviG/BS+LSPtNbdaEq5YSbz
         TbB1JbG/IgsELhEaLqTcuBjQUmKjg4VjXv16h8szGpxlKR+OhlB6D4jQaozQge/u/Kve
         npiXd2jEr8Ps6SZF2nRzX6ncltbRPZNldxUYDEVAHHH2W9z0/Yvtjf+cZqv8EOsaaqvq
         uQ9phXRXwSdIzVG2UIOt42a7Uh7DqA6G77ZWhjXF1iK3N0adH+gk7gcojf45ubuYKYjC
         vNTQ==
Content-Disposition: inline
In-Reply-To: <51BA8B83.8090607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On Fri, Jun 14, 2013 at 11:18:27AM +0800, Li Zefan wrote:
> Cont is short for container. control group was named process container
> at first, but then people found container already has a meaning in
> linux kernel.
> 
> Clean up the leftover variable name @cont.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.11-cpuset.

Thanks.

-- 
tejun
