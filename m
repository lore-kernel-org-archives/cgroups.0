From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 3/7] cgroup: restructure the failure path in
 cgroup_write_event_control()
Date: Thu, 1 Aug 2013 09:30:22 -0400
Message-ID: <20130801133022.GD24966@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C802.7070404@huawei.com>
 <20130731104448.GH2810@htj.dyndns.org>
 <51F9BF33.4060306@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DFWCHcRpC7YiDTVQ8ZRgyjXOhTCL8bmLMdR5urG+zN4=;
        b=adLD8G0mx8LYf5UcaGKY9d07cnYOe9PFZ41r4+eAKnQfu/mjmLr5giRfKSfcO0rOsh
         0DsAZY2wkzHqgk7EbaIUGaDbkivZgB4qBZemMxh1LrTEZFEQKxqcKAAfbYC10rao9KbE
         r88QJQqC+qoum/At8+iVPda3ZHcrozJvoSvTnKjkZe6gDL4fNerxOAw6urfqq2EI8oAf
         9FFv0SlRH4/rEGO+Mqz0uYRcZdCaR3DScI6JZ/bk0UJmK8Q4G+1VIsiYmcsqJzqjvJDH
         ZUXjaVQ3AsJ2H5MCtBhYnuDvN/U6+cQNTfkojUr/gTD739UCseQosDsx9QmcCYvxmOkx
         QSNA==
Content-Disposition: inline
In-Reply-To: <51F9BF33.4060306@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Thu, Aug 01, 2013 at 09:51:47AM +0800, Li Zefan wrote:
> It uses a single label and checks the validity of each pointer. This
> is err-prone, and actually we had a bug because one of the check was
> insufficient.
> 
> Use multi lables as we do in other places.
> 
> v2:
> - drop initializations of local variables.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
