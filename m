From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Sun, 21 Feb 2016 17:03:05 +0530
Message-ID: <CAG53R5XGJESb+_-FtjLsK+jHoEmbePLd==G2knBMOcrfdPm62Q@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
	<20160221074301.GK30450@leon.nu>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to;
        bh=CX/Izy5TJw80/0oxhPCJ8pkcOsOavVBHk//aM4T4GuI=;
        b=Od6x5YlftV1G4ApxqZ+xlHsUD16X5IprCDkXqjZNIFFUIIcZ7mItB+l40dUgp7QXz7
         fTHMz5eZNWegy4+WJw52WPFnbZPl8HnwdUL2CegXMwP0ijRAaNY1NO1yvi2LoP4mdJIf
         usgjXI3pMNBCgKCRwBL+qsD9W7WHft5FP9uBF20N2jxmeKqc8vGtqGq+9XnFISOBln3k
         SVwDYFZHw43vcS+IGePdgiDS5yiRAogi/co3sZ4rNavAnzNTSg0pyPz0ForPw1WKrALM
         eKsAamMWQk+v42UUxi95vfHS+IRmZ9ukKDpQAkiZ3Q7Jrm12DAa52D9L/LkhJQbJ0hil
         39yg==
In-Reply-To: <20160221074301.GK30450@leon.nu>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: leon@leon.nu, Parav Pandit <pandit.parav@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Sun, Feb 21, 2016 at 1:13 PM, Leon Romanovsky <leon@leon.nu> wrote:
> On Sat, Feb 20, 2016 at 04:30:04PM +0530, Parav Pandit wrote:
> Can you place this ifdef before declaring struct rdma_cgroup?
Yes. I missed out this cleanup. Done locally now.

> Thanks
