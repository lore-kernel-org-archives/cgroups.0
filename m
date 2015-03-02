From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] cpuset: initialize effective masks when
 clone_children is enabled
Date: Mon, 2 Mar 2015 11:55:54 -0500
Message-ID: <20150302165554.GI17694@htj.duckdns.org>
References: <54DD6D55.2070603@huawei.com>
 <54F40043.9050201@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=O2vB9IH5zW4QZYrOaaqLP/rFmfsTohzK/EH44DW9txM=;
        b=kt8/MuddqF78IDO7wLrkDL/MR8vXpw3prQB0X+PFhHolY7gjNPM7bHPNizT11WQd+s
         fH//n6WROKV8VfEwGfp+35XLe/W49A0Z/1PJ1XLjQ2hAAwXjMwMoM6usCDTOA4LsssZY
         +BLEfmXjyZCgJWUBRpgFdZS8/K9F7o3OJpfAkNN4xrBhthol6s3reJu+HnudJ1nQJ2UH
         Lh5qJh1+ttpavLXSg4eogKJ5EIY6RhUI1HAQPKVTKyPP8vjQIUQyJyjQ2JRnN0c6tkd8
         FIf/VHdkW+fujULBDR8z32PrFp+xwpvmFzdJse42LacfCbl9ACaO2440yb5nWz0JD2kV
         HSPQ==
Content-Disposition: inline
In-Reply-To: <54F40043.9050201@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: Christian Brauner <christianvanbrauner@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Mon, Mar 02, 2015 at 02:16:35PM +0800, Zefan Li wrote:
> Hi Tejun,
> 
> Could you pick up those bug fixes? Or should I ask Ingo/akpm to take
> care of them?

Sorry about the delay.  Applied to cgroup/for-4.0-fixes.  Will push
out in a week.

Thanks.

-- 
tejun
