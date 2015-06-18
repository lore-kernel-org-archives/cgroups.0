From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: add documentation for the PIDs controller
Date: Thu, 18 Jun 2015 13:50:00 -0400
Message-ID: <20150618175000.GB12934@mtj.duckdns.org>
References: <1434604276-10990-1-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FRsDG1Kdjr6qwhTpDhGAyTf45/sKz9syz56j8nJ7Ass=;
        b=0TONXyH8zMzwKjkBBpe1sG+v/sogYJ5Rbigb2Hvik1Wlp/dRxJJnV20PT4GLTm9CyA
         T0/k8unOfPJUImBIHrlWLqQoC1jNxVRMDYVKiL/AIfooPPvfG+W9K0yHVANOkweG4l57
         zAdetgFCjZ7byVcETTlJRdVjCNZlERKb7ZQf28/0EZS+qEgkOvk6Nc2fh402qc1XKbhd
         BWGDhGQOnU8O0F1jdEgUJ6fUpW0j961V+V8MX3MhEP8McBfskK7Qt6mYBVhtkTaQic57
         NZQzGEY68y6zqN6fwvYl38Epyct7/DT1/9yZ6yO7L6e83owyA8tzjbBXv1XRfhSR3iOv
         JzkA==
Content-Disposition: inline
In-Reply-To: <1434604276-10990-1-git-send-email-cyphar@cyphar.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Thu, Jun 18, 2015 at 03:11:16PM +1000, Aleksa Sarai wrote:
> The attached patch adds documentation concerning the PIDs controller.
> This should be applied alongside the rest of this patchset[1] (I'm not
> entirely sure what the kernel policy is for new patches that should be
> appended to an existing patchset).

I'll apply it together later.

Thanks.

-- 
tejun
