From: Tejun Heo <tj@kernel.org>
Subject: Re: cgroups iptables-restor: vmalloc: allocation failure
Date: Wed, 25 Jul 2018 07:14:43 -0700
Message-ID: <20180725141443.GS1934745@devbig577.frc2.facebook.com>
References: <a1a4eb7c-e85c-dc6d-cfac-6d40af302182@icdsoft.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AFEdrCnPLio2AtW9WGKB9yNRB5Gbbpv616xvzBH8Jf4=;
        b=Zbe0N03nKVOv2Q7VE7D9yngV67nKRE/Frp2YrmkOUdnlVUyJKCLFYpOpcsZNMPY1BR
         d8l3ZXL0lSqSkFL5RWtluMUEN/mjpfISNDGYnxlPbrwG2vkoFNiXB3BNvHbhvCn7hvfZ
         vfpUZmuHyxff2vTc2MIUDOGZvtZyynKz23sDpeoOBHQ6nW2TXgLJrLR1ZcZZl7bfqEnI
         9Vo3yxyqwpxNXHY+p6H352wkUfX2XaKHNbcu4RpeHVrbxaEr9KXKSUNrIeR+UE71vw30
         hLx63h1kBwAx11hGhxdW/ec1oCbMItdBU2m1vWsMc1+u4N558ht3H8sJtUVazJMtyvCa
         bYzA==
Content-Disposition: inline
In-Reply-To: <a1a4eb7c-e85c-dc6d-cfac-6d40af302182@icdsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Georgi Nikolov <gnikolov@icdsoft.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jul 25, 2018 at 02:50:01PM +0300, Georgi Nikolov wrote:
> I posted a kernel bug https://bugzilla.kernel.org/show_bug.cgi?id=200651 and
> i hope this is the correct place to discuss this.

That's just NORETRY vmalloc allocation failing under memory pressure.
Doesn't have much to do with cgroups except that there are also a
bunch of cgroups consuming memory.

Thanks.

-- 
tejun
