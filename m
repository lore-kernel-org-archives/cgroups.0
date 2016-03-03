From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 3 Mar 2016 10:14:53 +0200
Message-ID: <56D7F27D.1040702@mellanox.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
 <1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
 <20160302173949.GG29826@mtj.duckdns.org>
 <CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
 <CAG53R5WcbE8Hesb2sh6xg1fRLBOBt+VFo0L3U6WLPr3irtko8w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3I6UwDiRz0s5ZSYxNgkQCd1Paq7q5SLjHVq46r4eRDo=;
 b=eQkqISHmzPqHkBJRpws/iRq2c//cM+7zEwNBIX+E4B2FK7Xp0gCk6OruxggduB71oF2lbZKDqqOyO5ww+cwAKM//6Ew40o+qndm2aVRnNjW2IZ1Y8Q4h+0Uliq6PKrjEUgRIi7dwnxWE+TAN8tCZ1qWeEOMUAfMUwogwbQKzkF8=
In-Reply-To: <CAG53R5WcbE8Hesb2sh6xg1fRLBOBt+VFo0L3U6WLPr3irtko8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On 03/03/2016 05:18, Parav Pandit wrote:
> On Thu, Mar 3, 2016 at 1:28 AM, Parav Pandit <pandit.parav@gmail.com> wrote:
>> On Wed, Mar 2, 2016 at 11:09 PM, Tejun Heo <tj@kernel.org> wrote:
>>> Nothing seems to prevent @cg from going away if this races with
>>> @current being migrated to a different cgroup.  Have you run this with
>>> lockdep and rcu debugging enabled?  This should have triggered a
>>> warning.
> I am able to reproduce this race. Looking into how to address it.

If I understand correctly, task_css() requires rcu read lock being held.
Is task_get_css() suitable here?
