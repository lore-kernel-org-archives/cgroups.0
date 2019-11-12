From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-5.5] kernfs,cgroup: support 64bit inos and
 unify cgroup IDs
Date: Tue, 12 Nov 2019 08:19:02 -0800
Message-ID: <20191112161902.GG4163745@devbig004.ftw2.facebook.com>
References: <20191104235944.3470866-1-tj@kernel.org>
 <20191112160933.GA1690816@kroah.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CMydOXW3N0vSyHbPvuoqtInLO7hobFi83yAhmqo2dU4=;
        b=eAf+z0Rpeb2fieTOr8xgddn2osixFXBizD7/0a4W3L/UfN7U8sWKNJ1PGPtsaTilMA
         0/sd00Ca9nAwpl04nkEJG1ALQSb9jG4/QCamaF6n/6xuuKSU+wRPRaCmQhkkONUYpc8A
         FOubWXDBw/B0lyDlszjLb87CmvCt7hbbnzPBHWC0iZ1RZIOWkGtPwaAkpbHquY6O9iVg
         oy7s+fWarNxd20YJUlJO0ntB96qExasMYCOi/+nPNjTjYyXaWMo1aujU4KQyGgqJ9dL0
         EpSZz4ViHjokFwbycLhOoxuapulAd11oe+vyzVX+hYZUN05BzySNyf7eKOKhk2MTHjdS
         kPRw==
Content-Disposition: inline
In-Reply-To: <20191112160933.GA1690816@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net

Hello, Greg.

On Tue, Nov 12, 2019 at 05:09:33PM +0100, Greg KH wrote:
> Sorry for the delay.  Feel free to take all of these through your tree,
> that probably is easiest:
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks a lot for the review!  Applying 1-10 to cgroup/for-5.5.

-- 
tejun
