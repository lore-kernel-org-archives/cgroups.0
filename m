From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-4.3] cgroup,memcg: generalize event
 handling and enable notifications on "memory.events"
Date: Fri, 18 Sep 2015 17:40:12 -0400
Message-ID: <20150918214012.GA2893@mtj.duckdns.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MOw5Lc7Zlgnf6rQQphRPI5GFchMo+BDeEDVmeYx6pjo=;
        b=HxAYPms3yz2LgH6tLAiO13oHCptzr3EeCe25Tm+hrSnlajoonKmodOW7GEhlH3xBv9
         mAYt6vyWW4Dr20b/CBTiz/ZnSuB+QAIByCOk3GkcVG1NYbvexqQPMgCf/dCwfahaPjGv
         o8gWcv7fXvzGGXbkJPDGS+/mLuQ+jwzvhBHC8qE07I53737fVfgWrU3VBrt7crSSTRlm
         itZF1SgBdjqvBZRc9QW5xLvjQ7lTMcX5KfNoCWkkNGy6MKYXawdF0WHY3pEMCroFPARV
         KWtj/sEYCnk9i6hrbjT1iRfEUmo2Tc44QEyIXLXHbIeZKFoOpsdGcXM1cMJj4bpRFan2
         0ecQ==
Content-Disposition: inline
In-Reply-To: <1439315889-3492-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, lizefan@huawei.com
Cc: mhocko@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 11, 2015 at 01:58:01PM -0400, Tejun Heo wrote:
> Hello,
> 
> This patchset establishes conventions on low frequency events,
> converts "cgroup.populated" to "cgroup.events" accordingly,
> generalizes event handling and enable notifications for
> "memory.events".
> 
> This patchset contains the following eight patches.
> 
>  0001-cgroup-replace-cgroup.populated-with-cgroup.events.patch
>  0002-cgroup-replace-cftype-mode-with-CFTYPE_WORLD_WRITABL.patch
>  0003-cgroup-relocate-cgroup_populate_dir.patch
>  0004-cgroup-make-cgroup_addrm_files-clean-up-after-itself.patch
>  0005-cgroup-cosmetic-updates-to-rebind_subsystems.patch
>  0006-cgroup-restructure-file-creation-removal-handling.patch
>  0007-cgroup-generalize-obtaining-the-handles-of-and-notif.patch
>  0008-memcg-generate-file-modified-notifications-on-memory.patch

Applying 1-7 to cgroup/for-4.4.  Will post refreshed 0008 soon.

Thanks.

-- 
tejun
