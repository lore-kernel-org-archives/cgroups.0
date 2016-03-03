From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v2 cgroup/for-4.6] cgroup: make control mask updates
 modular and recursive
Date: Thu, 3 Mar 2016 09:59:32 -0500
Message-ID: <20160303145932.GD11029@mtj.duckdns.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HEsFXDI2yIdzJltCpGQ2xNMtLq2Ptwh2CTFOBuUof/o=;
        b=aO9m30802RZdvBLW9EOTEoW5npgP23VTVcBODjL7OrLHHS36cV+bVanzVjCwB7gsHd
         GC2oZ7k9sDPPCjdSfR9xX0bu+ciJTmbHHNohiyMhByCaX3zOGy/vQYpSzMHU2y0GDtc7
         jvlVnKHoEx699RQlrRi5ij8e0v/sd9zWDMWJ6uEHv0EbkqWCJZGZOeJRMkkpx1d8cVaT
         yrwJbU1hqG/TSkBS0o2NplLqtIr6WESrk24MdimmGruMuzh1Dij29ayOiDvkwBxLWWKA
         imMog/jdbvxLRerzut+dV9eKplaANZTEQKhQ7Ok1zZeb/VFT57pvODC4lpoGP+6wAGrR
         ZvTg==
Content-Disposition: inline
In-Reply-To: <1456351368-786-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Applied to cgroup/for-4.6.

Thanks.

-- 
tejun
