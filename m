From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v13 3/5] cgroup, block: implement task_get_css()
Date: Mon, 8 Jun 2015 18:22:02 +0900
Message-ID: <20150608092202.GI21465@mtj.duckdns.org>
References: <1433547736-11707-1-git-send-email-cyphar@cyphar.com>
 <1433548938-32560-3-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7QyTF81feJcUN3wnK/GMvgGEAjhWOLy8uOtKhgksy74=;
        b=srJPd1O6+xKuJH9Ssv6B5z6lM3/nlSJihf2v+VSqIUnJvENaSCn76k+uMdnQnfF4wl
         E3iZf9DYggKu8M28Pq0c539bPWHQVuGsIyO+1X73lLSzDCggcVzQZ9yneXR/mpGsvz+B
         EkIbS8rIpbfQksuO23GZqZVBavc6RQ7Wg4r2ZXDjRQHIa7OyEImgJ5WxMnKNluSo72OC
         dGqVMV8eWKcm7lFLKsePsbtrWJAq0sxva3UbtGxilQr6vK3hO1KVfa2rlAmcJhkY9Wiy
         vpXJwfx8//Yf0D/sInjFYL5xImt6ePBCHRfXZW6c2rQd/LiXvR5HLN1bJGpBEgGL+KNg
         kf7A==
Content-Disposition: inline
In-Reply-To: <1433548938-32560-3-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Sat, Jun 06, 2015 at 10:02:16AM +1000, Aleksa Sarai wrote:
> From: Tejun Heo <tj@kernel.org>
> 
> Implement task_get_css() which find and pins the css for the specified
> task and subsys.  As a task is always associated with an online css
> for every subsystem except while the css_set update is propagating,
> task_get_css() retries till css_tryget_online() succeeds.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>

Another form of this patch was already in block/for-4.2/writeback.  I
cherry picked that commit into cgroup/for-4.2 to avoid pulling the
whole thing into cgroup tree.

Thanks.

-- 
tejun
