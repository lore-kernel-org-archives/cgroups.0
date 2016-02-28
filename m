From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv6 3/3] rdmacg: Added documentation for rdmacg
Date: Sun, 28 Feb 2016 14:32:45 +0530
Message-ID: <CAG53R5XH2SbvNH=z7OL4v9i+r7cj4D8vPNZDSutjay3myoRkVw@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-4-git-send-email-pandit.parav@gmail.com>
	<56CDBD8B.4050503@mellanox.com>
	<CAG53R5XApY76+ACGsQvuWnQcPSsUfYqD1zxn=Dq_iFShUOxZYA@mail.gmail.com>
	<56D2B5EA.5090701@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=tbKUltP9B0fGiMrOyjSY3AwhxC86Ntl//b6o0syNMG0=;
        b=E4nst8eSjoO9v2eTRPTmfRtlETMqJd2n1GivljxGtRoK0UqCsyzIN7kUcR5F9WjP63
         k9D+deUroiPSRlk/qAP9el8PJFdmMTKWCXVsHXfcvJPt27xAQUVU3upJh/WHFb6a2cCm
         9YbYj4HMT/JH3h2TOvHs9txEuxXCQqhFrSeHVrdC8o3sm0PgD2AV4uPAStmPTgnhxAnB
         h/jqLe2utY64EdNn1L5GiUj9P6KzpoRa7WjPjd0nnpc9cPMB3rElX2SQ7TMlADDw4f+u
         TQd5/Sbbx3HFe+/eAP5OqoeZ9jdfcx9ynJE7eNDsGDPJplJl4VEHlZ4P0jZ1TOzPfa06
         3nYg==
In-Reply-To: <56D2B5EA.5090701@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

o.k. I will add a note there that IB stack would honor the limits
given by the rdma cgroup.

On Sun, Feb 28, 2016 at 2:25 PM, Haggai Eran <haggaie@mellanox.com> wrote:
> On 24/02/2016 17:21, Parav Pandit wrote:
>> On Wed, Feb 24, 2016 at 7:56 PM, Haggai Eran <haggaie@mellanox.com> wrote:
>>> On 20/02/2016 13:00, Parav Pandit wrote:
>>>> Added documentation for v1 and v2 version describing high
>>>> level design and usage examples on using rdma controller.
>>>>
>>>> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
>>>
>>> I think you might want to mention that resource limits are reflected
>>> in the results returned from ib_uverbs_query_device/ibv_query_device
>>> or printed from "ibv_devinfo -v".
>>>
>> Its valid point.
>> Since this documentation is for rdma controller, I was wondering
>> should I have it this documentation or should I add the uverbs_cmds.c?
>
> I was thinking it should be in the documentation because an application
> developer might look there first, without reading uverbs_cmd.c.
>
> Haggai
>
