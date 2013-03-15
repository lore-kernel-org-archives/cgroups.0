From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 3/4] fs: allow mknod in user namespaces
Date: Fri, 15 Mar 2013 18:49:53 +0400
Message-ID: <51433511.1020808@parallels.com>
References: <1363338823-25292-1-git-send-email-glommer@parallels.com> <1363338823-25292-4-git-send-email-glommer@parallels.com> <20130315143741.GE3782@sergelap>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130315143741.GE3782@sergelap>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com, "Eric W. Biederman" <ebiederm@xmission.com>, Serge Hallyn <serge.hallyn@canonical.com>, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, Aristeu Rozanski <aris@redhat.com>

On 03/15/2013 06:37 PM, Serge Hallyn wrote:
> Quoting Glauber Costa (glommer@parallels.com):
>> Since we have strict control on who access the devices, it should be
>> no problem to allow the device to appear.
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> Cc: Aristeu Rozanski <aris@redhat.com>
>> Cc: Eric Biederman <ebiederm@xmission.com>
>> Cc: Serge Hallyn <serge.hallyn@canonical.com>
>> ---
>>  fs/namei.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 8a34d79..d0b4549 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -3126,7 +3126,7 @@ int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
>>  	if (error)
>>  		return error;
>>  
>> -	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
>> +	if ((S_ISCHR(mode) || S_ISBLK(mode)) && !nsown_capable(CAP_MKNOD))
> 
> I realize you're arguing that devicens is enough, but how about
> doing inode_capable(dir, CAP_MKNOD) instead?
> 
I see no reason not to do it.


