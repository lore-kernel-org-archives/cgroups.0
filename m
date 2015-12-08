From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/7] cgroup: Add documentation for cgroup namespaces
Date: Tue, 8 Dec 2015 11:22:06 -0500
Message-ID: <20151208162206.GD30240@mtj.duckdns.org>
References: <1449529582-4075-1-git-send-email-serge.hallyn@ubuntu.com>
 <1449529582-4075-7-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=725/l9avqUKIvnc8w3gEOw3p0dMqXz9vaGX8R1mFG50=;
        b=qy7OC1lk5j4N8tqHAB0De2gg1PP9O0fsDaeWSNEuIqURFRf2WT7XNcmU+m+gm1r7tH
         x9NV4O+gW4V/HTsx5ynuNcRhqRSJ9XB7kDwwE5KYCG8OUiVR1e7bZMHuIb9SwUJKxZPK
         NsjGtHUg1higD5yes1xKqnJNYH9x0ODyhcGrvgW3JGq74RPVRuc3xT0CDV6GmuHB5ntH
         ERByZ1rXuqdErDIJb0qGO53OYLupL8mFIz0nYH9lLGKKNI298YqnYOIChfAmmuiGfgDc
         dWb7WpJlZPbx9piLl3Ah8R8jOJC2KC0+9Zs/kE07mFATN4jjSNtdDbE9/8xbvgekf7UF
         BGsA==
Content-Disposition: inline
In-Reply-To: <1449529582-4075-7-git-send-email-serge.hallyn@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: serge.hallyn@ubuntu.com
Cc: linux-kernel@vger.kernel.org, adityakali@google.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, lxc-devel@lists.linuxcontainers.org, akpm@linux-foundation.org, ebiederm@xmission.com, gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org

On Mon, Dec 07, 2015 at 05:06:21PM -0600, serge.hallyn@ubuntu.com wrote:
> From: Aditya Kali <adityakali@google.com>
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>
> Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> ---
>  Documentation/cgroups/namespace.txt |  142 +++++++++++++++++++++++++++++++++++

Please integrate the documentation into Documentation/cgroup.txt.

Thanks.

-- 
tejun
