From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/3] kselftest/cgroup: fix unexpected testing failure
 on test_memcontrol
Date: Fri, 24 May 2019 14:40:35 -0700
Message-ID: <20190524214035.GG374014@devbig004.ftw2.facebook.com>
References: <20190520030140.203605-1-alex.shi@linux.alibaba.com>
 <20190520030140.203605-2-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+M61dggFpUBm+TCSYA6xi0wuFiDoyPhijq/BdxGIPBk=;
        b=KkoOGgzCIRobqWvnIcfEZiben3HUa1XuJPtePp0Fmv0tK7T+s/bXdCY3CgTdQoanWp
         vJbJXh2IIyXXJW1N5krN9UdUMiz3YkwTDzz2NY5cXDNOSk8KmMWLeAo3/y7l8nEliot1
         HMIr7kLIvhW/C4B2PUYUgSQgsr6Lem76Ef1hnRGRJMHmmqwFeRUEeuSM81t6aLa/yWpw
         3Y0iOBZVkQeFv/Wbe6W18wXw5Vyc9lkjPa8o/yCIyrVVvQClK5sbOh/QdpoEiEFPtUaT
         pV4Pvh9403nTNfRkbI/CIJpNGnZHeWHe5Mt2D4X8pGBHEKo1h3WdwpSzdOzMgfev9GWI
         3o1g==
Content-Disposition: inline
In-Reply-To: <20190520030140.203605-2-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, Shuah Khan <shuah@kernel.org>, Roman Gushchin <guro@fb.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Jay Kamat <jgkamat@fb.com>, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

All three patches look good to me.  Please feel free to add my
acked-by.  Shuah, should I route these through cgroup tree or would
the kselftest tree be a better fit?

Thanks.

-- 
tejun
