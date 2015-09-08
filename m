From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 6/7] devcg: Added support to use RDMA device cgroup.
Date: Tue, 8 Sep 2015 15:52:15 +0530
Message-ID: <CAG53R5UC-xPn85ogcjS0WdNiyHxTJ_sJb-xFV9nc2ma_-wjtcg@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<1441658303-18081-7-git-send-email-pandit.parav@gmail.com>
	<55EE9EE2.3060804@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=DWkJmFMEDKLigV5moM2T9FGb/UQCaBxhs/aQe0JzYho=;
        b=Gr8Q55GimXmyZXxHH49Xt6CdcIqMBo/j2yfZjBrtVtwphtFiRHhaDrzLVHWYQ8ffAP
         puWS+ZdoNNHNBnUYWesQqaXmP8UeBvMrctT+QLAqZxnhL6P3FURU/vmhln8guNoC7hX2
         jbm3is8Y16tqZYkH0d/La7CdLqa7ebTXhizAZEkKT+jI2r5McDb2gl5NZHoM5MSUSn7k
         APYXQQrAsE8MU70yIcF7vtZnywz8hKV9R/+cnTwGqBCGqBNaQCHMmb3a6a3uyT1OEFEn
         UT4G0tKRZ4yI6siHHTa0UD0wsu9euDXf1hBnNkesONjO6JDlmICWgtSsNEdK/mK1DevW
         xpfQ==
In-Reply-To: <55EE9EE2.3060804@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Tue, Sep 8, 2015 at 2:10 PM, Haggai Eran <haggaie@mellanox.com> wrote:
> On 07/09/2015 23:38, Parav Pandit wrote:
>> +static void init_ucontext_lists(struct ib_ucontext *ucontext)
>> +{
>> +     INIT_LIST_HEAD(&ucontext->pd_list);
>> +     INIT_LIST_HEAD(&ucontext->mr_list);
>> +     INIT_LIST_HEAD(&ucontext->mw_list);
>> +     INIT_LIST_HEAD(&ucontext->cq_list);
>> +     INIT_LIST_HEAD(&ucontext->qp_list);
>> +     INIT_LIST_HEAD(&ucontext->srq_list);
>> +     INIT_LIST_HEAD(&ucontext->ah_list);
>> +     INIT_LIST_HEAD(&ucontext->xrcd_list);
>> +     INIT_LIST_HEAD(&ucontext->rule_list);
>> +}
>
> I don't see how this change is related to the patch.

Its not but code which I added makes this function to grow longer, so
to keep it to same readability level, I did the cleanup.
May be I can send separate patch for cleanup?
