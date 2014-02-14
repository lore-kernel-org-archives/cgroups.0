From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] kernfs: fix kernfs_node_from_dentry()
Date: Fri, 14 Feb 2014 17:04:24 -0500
Message-ID: <20140214220424.GA4634@mtj.dyndns.org>
References: <52FDDA77.6070606@huawei.com>
 <20140214160301.GE31544@htj.dyndns.org>
 <20140214220440.GA3998@kroah.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=F0xZB6eK7pxGfOM+LgN8OcwOK06aoZrbMxPOObJvRdQ=;
        b=0fqIsLMrwSZKbUohuibOFaXbS1fTbLX0UHT0klddKJL17eEdmsTLyoncNuiHPkgvfc
         N9qAxzeniNIKMlxBRTEzQEpgYLj/XMRe3X4T9N3Fp7lYb27kFV0auWMxBjOFFBN+en2G
         S2VyF9m5o7JpeATvvoGGVSUOo43ms2fOA/TTBS0B9wePUnz9QGy5BoNobsuzr8gSzfeW
         VFTxPh08fLXqujwTCYiabGwUQclf9HDiEPamGrWu2pAcaxC6bBihiBMZektagYHBXx1F
         CRZz3SeDsoJTlpmIDsXTK+CiKkyUaRO9CI1zSIgkZB0CzixAwc3G3Pp8pPlR4TiCfllw
         zxTA==
Content-Disposition: inline
In-Reply-To: <20140214220440.GA3998@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Li Zefan <lizefan@huawei.com>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Fri, Feb 14, 2014 at 02:04:40PM -0800, Greg Kroah-Hartman wrote:
> On Fri, Feb 14, 2014 at 11:03:01AM -0500, Tejun Heo wrote:
> > On Fri, Feb 14, 2014 at 04:57:27PM +0800, Li Zefan wrote:
> > > Currently kernfs_node_from_dentry() returns NULL for root dentry,
> > > because root_dentry->d_op == NULL.
> > > 
> > > Due to this bug cgroupstats_build() returns -EINVAL for root cgroup.
> > > 
> > >   # mount -t cgroup -o cpuacct /cgroup
> > >   # Documentation/accounting/getdelays -C /cgroup
> > >   fatal reply error,  errno -22
> > > 
> > > With this fix:
> > > 
> > >   # Documentation/accounting/getdelays -C /cgroup
> > >   sleeping 305, blocked 0, running 1, stopped 0, uninterruptible 1
> > > 
> > > Signed-off-by: Li Zefan <lizefan@huawei.com>
> > 
> > Acked-by: Tejun Heo <tj@kernel.org>
> 
> Is this needed for 3.14-final or 3.15-rc1?

3.15-rc1, so, driver-core-next.

Thanks.

-- 
tejun
