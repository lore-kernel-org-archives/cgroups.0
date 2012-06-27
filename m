From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Date: Wed, 27 Jun 2012 11:29:03 -0700
Message-ID: <20120627182903.GP15811@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=u8nBV/YVDHI2ic1fTsJ2jIkwrviqnp8JOAjRuzpRScI=;
        b=kTlbq6nS6Jprvd3K1l0oaYsJEitZVdNCoctK/7GHbvUG+FABsM0JBBZq4M6Fdw0d0f
         P80AKcj/VSM8ggkZfKRmXLnm1je9fFU1OrZ1SFP3qeUUwv333RfzkDoSy6BmOzn2TDZN
         dkvFKBjW0Nkt64D+w3vRLqc68ex5/fhoAUbb3oa49RJFQVBdV6XOJZaWFVf9CqwEqGqv
         gqawIy+PkF99syM0qSTbUTUorTKzIoETqovK1nydIoYcjHm7CL+wTo312IA0nuEVBjbI
         J5hzgceM8pi4pq5OvXIkyTKQ8n11dBXMPjY8ovyZm6KbH600bdz95zzKmpb2W4OoPhY+
         IkqQ==
Content-Disposition: inline
In-Reply-To: <E061084CB90FCE4F89232A6CF839683B32B52291-SY/3K1LPFSqBBfbIEMVH7QK1hpo4iccwjNknBlVQO8k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Sun, Jun 24, 2012 at 07:08:07PM +0000, shyju pv wrote:
> Hi,
> Observed a crash on 3.5-rc3 with cgroup tests from LTP(Stable April,2012 release)on Dell Inspiron 1526[Intel(R) Core2Duo T7250, MEM 4GB] and also on another x86 quad core target(4GB RAM).
> LTP test case: cgroup_regression_test.sh(test 4,7 and 9 crashes randomly when the test cases are executed in order)
> Shyju
> 
> [  532.805905] BUG: Dentry ffff8801164db490{i=491b,n=/} still in use (1) [unmount of cgroup cgrou

Hmm... fa980ca87d "cgroup: superblock can't be released with active
dentries" is supposed to have fixed that.  Looking into it.

Thanks.

-- 
tejun
